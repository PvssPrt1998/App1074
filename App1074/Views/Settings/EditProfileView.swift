import SwiftUI

struct EditProfileView: View {
    
    @ObservedObject var viewModel = VMF.shared.editProfileViewModel()
    @Binding var show: Bool
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.bgMain.opacity(0.3))
                    .frame(width: 36, height: 5)
                    .padding(.top, 5)
                header
                    .padding(.horizontal, 8)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ProfileImageView(imageData: $viewModel.image, image: setImage(viewModel.profile?.image))
                        .padding(.top, 20)
                    VStack(spacing: 17) {
                        TextFieldCustom(text: $viewModel.name, prefix: "Name", placeholder: "Enter")
                        TextFieldCustom(text: $viewModel.surname, prefix: "Surname", placeholder: "Enter")
                        TextFieldCustom(text: $viewModel.target, prefix: "Target", placeholder: "Enter")
                        TextFieldCustom(text: $viewModel.birthday, prefix: "Birthday", placeholder: "Enter")
                            .keyboardType(.numberPad)
                            .onChange(of: viewModel.birthday, perform: { newValue in
                                birthdayValidation(newValue)
                            })
                    }
                    .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16))
                }
                
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    private func birthdayValidation(_ newValue: String) {
        let filtered = newValue.filter { Set("0123456789").contains($0) }
        
        if filtered != "" {
            var filterIterable = filtered.makeIterator()
            var index = 0
            var value = ""
            while let c = filterIterable.next() {
                if index == 0 || index == 1 || index == 3 || index == 5 || index == 6 || index == 7 {
                    value = value + "\(c)"
                }
                if index == 2 || index == 4 {
                    value = value + ".\(c)"
                }
                index += 1
            }
            viewModel.birthday = value
        } else  {
            viewModel.birthday = ""
        }
    }
    
    private func setImage(_ data: Data?) -> Image? {
        guard let data = data,
            let image = UIImage(data: data) else {
            return nil
        }
        return Image(uiImage: image)
    }
    
    private var header: some View {
        Text("Edit profile")
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.white)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .overlay(
                HStack {
                    Button {
                        show = false
                    } label: {
                        HStack(spacing: 3) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.cPrimary)
                            
                            Text("Back")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.cPrimary)
                        }
                        .padding(.horizontal, 8)
                    }
                    Spacer()
                    Button {
                        viewModel.save()
                        show = false
                    } label: {
                        Text("Save")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.cPrimary)
                    }
                    .padding(.horizontal, 8)
                }
                , alignment: .leading
            )
    }
}

struct EditProfileView_Preview: PreviewProvider {
    
    @State static var show = true
    
    static var previews: some View {
        EditProfileView(show: $show)
    }
}

final class EditProfileViewModel: ObservableObject {
    
    let dm: DataManager
    @Published var profile: Profile?
    
    @Published var image: Data?
    @Published var name = ""
    @Published var surname = ""
    @Published var birthday = ""
    @Published var target = ""
    
    init(dm: DataManager) {
        self.dm = dm
        profile = dm.profile
        image = profile?.image
        name = profile?.name ?? ""
        surname = profile?.surname ?? ""
        birthday = profile?.birthday ?? ""
        target = profile?.target ?? ""
    }
    
    func save() {
        dm.saveProfile(Profile(image: image, name: name, surname: surname, target: target, birthday: birthday))
    }
}
