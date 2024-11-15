import SwiftUI

struct Tab: View {
    
    @State var selection = 0
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(rgbColorCodeRed: 153, green: 153, blue: 153, alpha: 1)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(rgbColorCodeRed: 153, green: 153, blue: 153, alpha: 1)]

        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(rgbColorCodeRed: 254, green: 197, blue: 44, alpha: 1)
        //UIColor(rgbColorCodeRed: 57, green: 229, blue: 123, alpha: 1)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(rgbColorCodeRed: 254, green: 197, blue: 44, alpha: 1)]
        appearance.backgroundColor = UIColor.bgSecond
        appearance.shadowColor = .white.withAlphaComponent(0.15)
        appearance.shadowImage = UIImage(named: "tab-shadow")?.withRenderingMode(.alwaysTemplate)
        UITabBar.appearance().backgroundColor = .bgSecond
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                LevelView()
                    .tabItem { VStack {
                        tabViewImage("house")
                        Text("Levels") .font(.system(size: 10, weight: .medium))
                    } }
                    .tag(0)
                ChallengesView()
                    .tabItem { VStack {
                        Image(selection == 1 ? "tab1Selected" : "tab1")
                        Text("Challenge") .font(.system(size: 10, weight: .medium))
                    } }
                    .tag(1)
                AchievementsView()
                    .tabItem { VStack{
                        tabViewImage("flag.2.crossed")
                        Text("Achievement")
                            .font(.system(size: 10, weight: .medium))
                    }
                    }
                    .tag(2)
                SettingsView()
                    .tabItem {
                        VStack {
                            tabViewImage("person.crop.circle")
                            Text("Profile") .font(.system(size: 10, weight: .medium))
                        }
                    }
                    .tag(3)
            }

        }
    }
    
    @ViewBuilder func tabViewImage(_ systemName: String) -> some View {
        if #available(iOS 15.0, *) {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .medium))
                .environment(\.symbolVariants, .none)
        } else {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .medium))
        }
    }
}

#Preview {
    Tab()
}



extension UIColor {
   convenience init(rgbColorCodeRed red: Int, green: Int, blue: Int, alpha: CGFloat) {

     let redPart: CGFloat = CGFloat(red) / 255
     let greenPart: CGFloat = CGFloat(green) / 255
     let bluePart: CGFloat = CGFloat(blue) / 255

     self.init(red: redPart, green: greenPart, blue: bluePart, alpha: alpha)
   }
}
