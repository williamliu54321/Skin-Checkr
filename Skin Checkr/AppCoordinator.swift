import Foundation
import SwiftUI
import SuperwallKit

@MainActor
final class AppCoordinator: ObservableObject {
    enum Screen {
        case onboarding
        case home
        case getImageView
        case cameraInterfaceView
        case savedPhotosLibraryView
        case photosConfirmationView
        case resultsView
        case analysisView
    }

    @Published var currentScreen: Screen = .home
    @Published var capturedImage: UIImage?
    @Published var analysisResult: String?

    private var onboardingCoordinator: OnboardingCoordinator?

    init() {
        Task {
            self.checkInitialFlow()
        }
    }
    
    func checkInitialFlow() {
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
        if !hasCompletedOnboarding {
            startOnboarding()
        } else {
            self.currentScreen = .home
        }
    }
    
    func startOnboarding() {
        let coordinator = OnboardingCoordinator(parentCoordinator: self)
        self.onboardingCoordinator = coordinator
        self.currentScreen = .onboarding
    }
    
    func onboardingCompleted() {
        withAnimation(.easeInOut(duration: 0.4)) {
            self.onboardingCoordinator = nil
            self.currentScreen = .home
        }
    }
    
    func makeCameraInterfaceView() -> some View {
        return CameraFlowContainerView(
                        onBack: { [weak self] in
                withAnimation {
                    self?.currentScreen = .getImageView
                }
            },
            
            onPhotoTaken: { [weak self] image in
                self?.capturedImage = image
                
                withAnimation {
                    self?.currentScreen = .photosConfirmationView
                }
            }
        )
    }

    func makePhotosConfirmationView() -> some View {
        // Safely unwrap the image from the coordinator's state.
        if let image = capturedImage {
            
            // 1. CREATE THE VIEWMODEL FIRST.
            //    Inject the image and all the navigation logic into the ViewModel.
            let viewModel = PhotosConfirmationViewModel(
                image: image,
                onBack: { [weak self] in
                    withAnimation {
                        self?.currentScreen = .getImageView
                    }
                },
                onRetake: { [weak self] in
                    withAnimation {
                        self?.currentScreen = .cameraInterfaceView
                    }
                },
                onStartAnalysis: { [weak self] _ in
                    print("✅ Coordinator received 'Start Analysis' signal. Attempting to navigate...")
                    withAnimation {
                        self?.currentScreen = .analysisView
                    }
                }
            )
            
            // 2. CREATE THE VIEW and pass it the single ViewModel you just made.
            return AnyView(PhotosConfirmationView(viewModel: viewModel))
            
        } else {
            // Fallback view remains the same.
            return AnyView(Text("Error: No image available."))
        }
    }
    
    // B. Add the new maker function for the AnalyzingView
    func makeAnalysingView() -> some View {
        AnalyzingView(
            onAnalysisComplete: { [weak self] in
                // When the 4-second "analysis" is done, we call the paywall logic.
                self?.startAnalysisPaywall()
            }
        )
    }

    // In AppCoordinator.swift

    func startAnalysisPaywall() {
        Task {
            // Step 1: Check if the user is ALREADY subscribed before showing anything.
            if await checkSubscriptionStatus() {
                
                // --- PATH A: USER IS ALREADY SUBSCRIBED ---
                // They get to see the results immediately, no paywall needed.
                print("User is already subscribed. Navigating to results.")
                withAnimation {
                    self.currentScreen = .resultsView
                }
                
            } else {
                
                // --- PATH B: USER IS NOT SUBSCRIBED ---
                // Present the paywall.
                print("User is not subscribed. Showing paywall...")
                
                Superwall.shared.register(placement: "MainPaywall") {
                    
                    // --- THIS CODE RUNS AFTER THE PAYWALL IS DISMISSED ---
                    print("Paywall was dismissed. Re-checking subscription status...")
                    
                    // We must check the status again to see WHY it was dismissed.
                    Task {
                        if await self.checkSubscriptionStatus() {
                            
                            // If status is now TRUE, it means the user just purchased.
                            print("Purchase successful! Navigating to results.")
                            await MainActor.run {
                                withAnimation {
                                    self.currentScreen = .resultsView
                                }
                            }
                            
                        } else {
                            
                            // If status is still FALSE, it means the user tapped the 'X' button.
                            print("User dismissed without purchasing. Navigating home.")
                            await MainActor.run {
                                withAnimation {
                                    // THIS IS THE LOGIC YOU ASKED FOR
                                    self.currentScreen = .resultsView
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func makeHomeView() -> some View {
        let viewModel = HomeViewModel(
            placePaywall: { [weak self] in
                self?.startMainPaywall()
            },
            showGetImageView: { [weak self] in
                withAnimation {
                    self?.currentScreen = .getImageView
                }
            }
        )
        return HomeView(viewModel: viewModel)
    }
    
    func makeOnboardingView() -> some View {
        if let coordinator = onboardingCoordinator {
            return AnyView(OnboardingView(coordinator: coordinator))
        } else {
            return AnyView(ProgressView("Loading..."))
        }
    }
    
    func makeGetImageView() -> some View {
         let viewModel = GetImageViewModel(
             onBack: { [weak self] in
                 withAnimation {
                     self?.currentScreen = .home
                 }
             },
             onTakePhoto: { [weak self] in
                 withAnimation {
                     self?.currentScreen = .cameraInterfaceView
                 }
             },
             // PROVIDE THE NEW CLOSURE: The logic for what to do after a photo is selected.
             // This is the same logic as the camera path!
             onPhotoSelected: { [weak self] image in
                 self?.capturedImage = image
                 withAnimation {
                     self?.currentScreen = .photosConfirmationView
                 }
             }
         )
         return GetImageView(viewModel: viewModel)
     }
    
    // In AppCoordinator.swift

    func makeResultsView() -> some View {
        
        // 1. SAFETY FIRST: Guard Clause
        //    Safely unwrap the data needed for this screen. If either the image or the
        //    analysis result is missing, we show a user-friendly error view instead of crashing.
        guard let image = capturedImage, let resultString = analysisResult else {
            return AnyView(
                VStack {
                    Text("Error: Missing analysis data.")
                    Button("Go Home") {
                        withAnimation {
                            self.currentScreen = .home
                        }
                    }
                }
            )
        }
        
        let viewModel = ResultsViewModel(
            
            // --- Data Injection ---
            // TODO: In a real app, you would parse the `resultString` from OpenAI
            // to get these specific values. For now, we use placeholders.
            riskLevel: "Medium Risk",
            asymmetry: "Low",
            border: "Low",
            color: "Medium",
            imageData: image,
            aiNotes: resultString, // Pass the real AI notes
            
            // --- Action Injection ---
            // This is where you define what each button does.
            
            // Logic for the "Back" button
            onBack: { [weak self] in
                withAnimation {
                    // Go back to the previous screen (the photo confirmation screen).
                    self?.currentScreen = .photosConfirmationView
                }
            },
            
            // Logic for the "Save this Mole" button
            onDone: { [weak self] in
                withAnimation {
                    // Navigate back to the main home screen.
                    self?.currentScreen = .home
                }
            }, onSave: {
                // Here you would implement the logic to save the image and its
                // analysis data to Core Data, SwiftData, or a server.
                print("Save action triggered in coordinator. Logic to persist data goes here.")
                // For now, it does nothing but print.
            }
        )
        
        // 3. CREATE THE VIEW
        //    Finally, create the ResultsView and pass it the fully configured ViewModel.
        //    We wrap it in AnyView because the guard clause can return a different view type.
        return AnyView(ResultsView(viewModel: viewModel))
    }
        
    func startMainPaywall() {
        Task {
            if await checkSubscriptionStatus() {
                self.currentScreen = .home
            } else {
                Superwall.shared.register(placement: "MainPaywall") {
                    self.currentScreen = .home
                }
            }
        }
    }

    func checkSubscriptionStatus() async -> Bool {
        let status = await Superwall.shared.subscriptionStatus
        if case .active = status {
            return true
        } else {
            return false
        }
    }
    
     func checkSubscriptionStatusAndUpdateUI() {
        Task {
            if await checkSubscriptionStatus() {
                self.currentScreen = .home
            } else {
                Superwall.shared.register(placement: "MainPaywall") {
                    self.currentScreen = .home
                }
            }
        }
    }
    
    func restorePurchases() {
        Task {
            await Superwall.shared.restorePurchases()
            if await checkSubscriptionStatus() {
                self.currentScreen = .home
            } else {
                Superwall.shared.register(placement: "MainPaywall") {
                    self.currentScreen = .home
                }
            }
        }
    }
}
