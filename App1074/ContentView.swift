import SwiftUI

struct ContentView: View {
    
    @State var screen: Screen = .splash
    
    var body: some View {
        switch screen {
        case .splash:
            Splash(screen: $screen, dataC: VMF.shared.dm)
        case .profile:
            ProfileView(screen: $screen)
        case .main:
            Tab()
        }
    }
}

#Preview {
    ContentView()
}

enum Screen {
    case splash
    case main
    case profile
}
