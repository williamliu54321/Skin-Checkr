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
    }

    @Published var currentScreen: Screen = .home
    @Published var capturedImage: UIImage?

    private var onboardingCoordinator: OnboardingCoordinator?

    init() {
        Task {
            self.checkInitialFlow()
        }
    }
    
    // --- STEP 2: DEFINING THE HANDOFF LOGIC ---
    // This logic is defined here, inside the function that creates the camera view.
    func makeCameraInterfaceView() -> some View {
        // We create the CameraFlowContainerView and give it the "instructions"
        // for what to do when its events happen.
        return CameraFlowContainerView(
            
            // Instruction for the 'Back' button
            onBack: { [weak self] in
                withAnimation {
                    self?.currentScreen = .getImageView
                }
            },
            
            // Instruction for what happens AFTER a photo is taken
            // This is the critical handoff from the camera to the coordinator.
            onPhotoTaken: { [weak self] image in
                // 1. The coordinator CATCHES the image and stores it.
                self?.capturedImage = image
                
                // 2. The coordinator NAVIGATES to the next screen.
                withAnimation {
                    self?.currentScreen = .photosConfirmationView
                }
            }
        )
    }

    // --- STEP 3: USING THE HANDED-OFF DATA ---
    // This function uses the `capturedImage` that was set in the step above.
    // In AppCoordinator.swift

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
                onStartAnalysis: { [weak self] confirmedImage in
                    // This logic is now passed to the ViewModel, which will call it
                    // when its startAnalysisButtonTapped() method is triggered.
                    print("Starting analysis on the confirmed image...")
                    withAnimation {
                        self?.currentScreen = .home
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

    // --- Other Functions (No changes needed below this line) ---
    
    func checkInitialFlow() {
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
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
            onUploadPhoto: { [weak self] in
                withAnimation {
                    self?.currentScreen = .savedPhotosLibraryView
                }
            }
        )
        return GetImageView(viewModel: viewModel)
    }
    
    func makeSavedPhotosLibraryView() -> some View {
        VStack {
            Text("Photo Picker Placeholder")
            Button("Go Back") {
                withAnimation {
                    self.currentScreen = .getImageView
                }
            }
        }
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
