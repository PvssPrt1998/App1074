import SwiftUI

struct Splash: View {
    
    @AppStorage("firstLaunch") var firstLaunch = true
    @State var value: Double = 0
    @Binding var screen: Screen
    let dataC: DataManager
    
    var body: some View {
        ZStack {
            Image("SplashBg")
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 144) {
                ZStack {
                    Circle()
                        .fill(.bgMain)
                        .padding(10)
                    Image("SplashLogo")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 43)
                }
                
                HStack(spacing: 8) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .frame(width: 30, height: 30)
                        .scaleEffect(1.5, anchor: .center)
                    Text("\(Int(value * 100))%")
                        .font(.body.weight(.regular))
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            stroke()
            dataC.load()
        }
    }
    
    private func stroke() {
        if value < 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                self.value += 0.02
                self.stroke()
            }
        } else {
            if !dataC.loaded {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                    self.stroke()
                }
            } else {
                if firstLaunch {
                    firstLaunch = false
                    screen = .profile
                } else {
                    screen = .main
                }
            }
        }
    }
}

struct Splash_Preview: PreviewProvider {
    
    @State static var showSplash: Screen = .splash
    
    static var previews: some View {
        Splash(screen: $showSplash, dataC: DataManager())
    }
}
