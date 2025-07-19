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
