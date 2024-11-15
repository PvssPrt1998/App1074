import SwiftUI
import Combine

struct SettingsView: View {
    
    @State var showDeleteAlert = false
    
    @State var showEditProfile = false
    @Environment(\.openURL) var openURL
    @ObservedObject var viewModel = VMF.shared.settingsViewModel()
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(
                        Button {
                            showEditProfile = true
                        } label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.cPrimary)
                                .frame(width: 22, height: 22)
                                .background(Color.bgMain)
                        }
                        ,alignment: .trailing
                    )
                    .padding(.horizontal, 16)
                profileView
                    .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16))
                settingsView
                    .padding(EdgeInsets(top: 85, leading: 16, bottom: 0, trailing: 16))
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .sheet(isPresented: $showEditProfile, content: {
            EditProfileView(show: $showEditProfile)
        })
    }
    
    private func setImage(_ data: Data?) -> Image {
        guard let data = data,
            let image = UIImage(data: data) else {
            return Image(systemName: "camera.fill")
        }
        return Image(uiImage: image)
    }
    
    private var profileView: some View {
        HStack {
            if let image = viewModel.profile?.image {
                setImage(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 133, height: 133)
                    .clipShape(.circle)
                    .clipped()
            } else {
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 70)
                    .frame(width: 133, height: 133)
                    .background(Color.c157157157)
                    .clipShape(.circle)
                    .clipped()
            }
            
            if let profile = viewModel.profile {
                if !(profile.name == "" && profile.surname == "" && profile.target == "" && profile.birthday == "") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(profile.name + " " + profile.surname)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.cPrimary)
                        Text(profile.birthday)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        Text(profile.target)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                }
            }
            
        }
    }
    
    private var settingsView: some View {
        VStack(spacing: 17) {
            Button {
                actionSheet()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.c546063)
                    Text("Share app")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.c546063)
                }
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 48)
                .background(Color.cPrimary)
                .clipShape(.rect(cornerRadius: 12))
            }
            Button {
                if let url = URL(string: "https://www.termsfeed.com/live/53b3ddc4-1493-4540-af72-64b70eea6f0c") {
                    openURL(url)
                }
            } label: {
                HStack(spacing: 4) {
                    Image("bookPages")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 22)
                    Text("Terms of use")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.c546063)
                }
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 48)
                .background(Color.cPrimary)
                .clipShape(.rect(cornerRadius: 12))
            }
            Button {
                if let url = URL(string: "https://www.termsfeed.com/live/cf85f44a-7c3c-4499-9066-07fd209b1976") {
                    openURL(url)
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.c546063)
                    Text("Privacy")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.c546063)
                }
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 48)
                .background(Color.cPrimary)
                .clipShape(.rect(cornerRadius: 12))
            }
            Button {
                showDeleteAlert = true
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "minus.circle")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.c546063)
                    Text("Delete account")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.c546063)
                }
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 48)
                .background(Color.cPrimary)
                .clipShape(.rect(cornerRadius: 12))
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(title: Text("Delete"), message: Text("Are you sure you want to delete?"), primaryButton: .default(Text("Delete"), action: {
                    viewModel.deleteAccount()
                }), secondaryButton: .destructive(Text("Close")))
            }
        }
    }
    
    func actionSheet() {
        guard let urlShare = URL(string: "https://apps.apple.com/us/app/melrewards-unlock-fun/id6738141217")  else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        if #available(iOS 15.0, *) {
            UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController?
            .present(activityVC, animated: true, completion: nil)
        } else {
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
}

#Preview {
    SettingsView()
}

final class SettingsViewModel: ObservableObject {
    
    let dm: DataManager
    
    @Published var profile: Profile?
    
    private var profileCancellable: AnyCancellable?
    
    init(dm: DataManager) {
        self.dm = dm
        profile = dm.profile
        
        profileCancellable = dm.$profile.sink { [weak self] value in
            self?.profile = value
        }
    }
    
    func deleteAccount() {
        dm.saveProfile(Profile(image: nil, name: "", surname: "", target: "", birthday: ""))
    }
}
