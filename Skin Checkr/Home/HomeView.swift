import SwiftUI

struct ScanReminder: Identifiable {
    var id = UUID()
    var location: String
    var dueDate: Date
}

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    @State private var reminders: [ScanReminder] = [
        ScanReminder(location: "Right Shoulder", dueDate: Date())
    ]
    
    var body: some View {
        // REMOVE THE NavigationView { ... } WRAPPER FROM HERE
        
        // The ZStack and VStack are now the top-level views.
        // Since this view is now "transparent", it will sit perfectly
        // on top of the gradient background you defined in ContentView.
        ZStack {
            // Main content
            VStack(spacing: 30) {
                Text("Skin Checkr")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                
                Button(action: {
                    viewModel.onStartMainPaywall()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                        Text("Get Pro")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background(Color("skyBlue").opacity(0.2))
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color("lightBlue"), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                }
                Spacer()
                
                Button(action: {
                    viewModel.onShowGetImageView()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Start a New Scan")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .frame(width: 260, height: 60)
                    .foregroundColor(.white)
                    .background(Color("skyBlue"))
                    .cornerRadius(30)
                    .shadow(color: Color("deeperBlue").opacity(0.3), radius: 10, x: 0, y: 5)
                }
                
                Spacer()
            }
        }
    }
}


// The preview will now likely have a black background, which is fine.
// The important thing is how it looks when run inside your ContentView.
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        // To make the preview look better, you can wrap it in a ZStack
        // with the gradient, just for previewing purposes.
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("darkBlue"),
                    Color("deeperBlue")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            HomeView(viewModel: .mock)
        }
    }
}
