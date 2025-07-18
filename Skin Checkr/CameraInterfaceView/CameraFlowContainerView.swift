import SwiftUI

struct CameraFlowContainerView: View {
    // This container's ONLY job is to own the StateObject.
    // It is created LAZILY, only when this container view is put on screen.
    // SwiftUI guarantees it will be created ONCE and then kept alive.
    // This is the core fix for the crash.
    @StateObject private var cameraViewModel: CameraInterfaceViewModel

    /// This initializer takes the closures it needs to build its ViewModel.
    /// It has no knowledge of a "Coordinator".
    init(
        onBack: @escaping () -> Void,
        onPhotoTaken: @escaping (UIImage) -> Void
    ) {
        // We create the StateObject here, in this View's own init.
        // This is the safe, canonical way to do it.
        _cameraViewModel = StateObject(wrappedValue: CameraInterfaceViewModel(
            onBack: onBack,
            onPhotoTaken: onPhotoTaken
        ))
    }

    var body: some View {
        // This container doesn't have its own UI. It simply displays the
        // actual CameraInterfaceView, passing down the ViewModel it safely owns.
        CameraInterfaceView(viewModel: cameraViewModel)
    }
}
