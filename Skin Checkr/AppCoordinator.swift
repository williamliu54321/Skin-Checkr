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
    
    private var analysisService: AnalysisServiceProtocol? // <-- Change to optional 'var'

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
        if let image = capturedImage {
            let viewModel = PhotosConfirmationViewModel(
                image: image,
                onBack: { [weak self] in withAnimation { self?.currentScreen = .getImageView } },
                onRetake: { [weak self] in withAnimation { self?.currentScreen = .cameraInterfaceView } },
                
                // THIS IS THE CHANGE
                // The button tap now calls a single, dedicated function to handle the flow.
                onStartAnalysis: { [weak self] confirmedImage in
                    self?.beginAnalysisFlow(with: confirmedImage)
                }
            )
            return AnyView(PhotosConfirmationView(viewModel: viewModel))
        } else {
            return AnyView(Text("Error: No image available."))
        }
    }
    
    // B. Add the new maker function for the AnalyzingView
    // UPDATE THIS FUNCTION
    func makeAnalysingView() -> some View {
        // This view is now just a spinner. It doesn't need any completion handlers.
        AnalyzingView()
    }

    // In AppCoordinator.swift

    // ADD THIS NEW FUNCTION to your AppCoordinator.
    // It combines the paywall check and the network call.
//    func beginAnalysisFlow(with image: UIImage) {
//        Task {
//            // First, check if the user has access (is subscribed).
//            if await checkSubscriptionStatus() {
//                // If they are, perform the analysis directly.
//                await performAnalysis(with: image)
//            } else {
//                // If not, show the paywall.
//                Superwall.shared.register(placement: "MainPaywall") {
//                    // This is the combined dismiss/purchase handler.
//                    Task {
//                        if await self.checkSubscriptionStatus() {
//                            // User just purchased. Now perform the analysis.
//                            await self.performAnalysis(with: image)
//                        } else {
//                            // User dismissed. Go home.
//                            await MainActor.run {
//                                withAnimation { self.currentScreen = .home  }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    func beginAnalysisFlow(with image: UIImage) {
        Task {
            // First, check if the user has access (is subscribed).
            if await checkSubscriptionStatus() {
                // If they are, perform the analysis directly.
                await performAnalysis(with: image)
            } else {
                // If not, show the paywall.
                Superwall.shared.register(placement: "MainPaywall") {
                    // This is the combined dismiss/purchase handler.
                    // For testing, we will run the analysis regardless of the outcome.
                    Task {
                        // The original 'if/else' check is no longer needed here
                        // because both purchase and dismiss now lead to the same action.
                        
                        // Whether they purchased or dismissed, we proceed with the analysis.
                        await self.performAnalysis(with: image)
                    }
                }
            }
        }
    }
    
    private func performAnalysis(with image: UIImage) async {
        // 1. Show the loading screen.
        await MainActor.run {
            withAnimation { self.currentScreen = .analysisView }
        }
        
        // --- THIS IS THE LAZY INITIALIZATION ---
        // If the service hasn't been created yet, create it now.
        if self.analysisService == nil {
            self.analysisService = AnalysisService()
        }
        
        // Use 'guard let' to safely unwrap the now-guaranteed service.
        guard let analysisService = self.analysisService else {
            // This case should theoretically never happen, but it's good practice.
            print("❌ Error: Analysis service could not be created.")
            await MainActor.run {
                withAnimation { self.currentScreen = .home }
            }
            return
        }
        
        do {
            // 2. Call the backend using the now-unwrapped service.
            let resultText = try await analysisService.analyzeImage(image: image)
            
            // ... (the rest of your function remains the same)
            self.analysisResult = resultText
            await MainActor.run {
                withAnimation { self.currentScreen = .resultsView }
            }
        } catch {
            // 5. Handle any errors.
            print("❌ Analysis failed: \(error.localizedDescription)")
            // Navigate back home or show an error message.
            await MainActor.run {
                withAnimation { self.currentScreen = .home }
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
