import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var viewModel = VMF.shared.createProfileViewModel()
    
    @State var selection = 0
    @Binding var screen: Screen
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                }
            ScrollView([], showsIndicators: false) {
                TabView(selection: $selection) {
                    welcomeView.tag(0)
                    createProfileView.tag(1)
                    endView.tag(2)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
            
            Button {
                if selection < 2 {
                    if selection == 1 {
                        viewModel.saveProfile()
                    }
                    withAnimation {
                        selection += 1
                    }
                } else {
                    withAnimation {
                        screen = .main
                    }
                }
            } label: {
                Text(selection == 0 ? "Begin" : "Next")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.c546063)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.cPrimary)
                    .clipShape(.rect(cornerRadius: 12))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.keyboard)
        }
        .onAppear {
            UIScrollView.appearance().bounces = false
            UIScrollView.appearance().isScrollEnabled = false
        }
        .onDisappear {
            UIScrollView.appearance().bounces = true
            UIScrollView.appearance().isScrollEnabled = true
        }
    }
    
    private var welcomeView: some View {
        VStack(spacing: 26) {
            Text("Welcome to\nFitRewards")
                .font(.system(size: 36, weight: .semibold))
                .foregroundColor(.cPrimary)
                .multilineTextAlignment(.center)
            Text("Start training right now")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 209)
        .frame(maxHeight: .infinity, alignment: .top)
    }
    private var createProfileView: some View {
        VStack(spacing: 25) {
            ProfileImageView(imageData: $viewModel.image)
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
        }
        .padding(.horizontal, 16)
        .padding(.top, 40)
        .frame(maxHeight: .infinity, alignment: .top)
    }
    private var endView: some View {
        Text("Congratulations!\nYour profile has\nbeen registered")
            .font(.system(size: 36, weight: .semibold))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(.top, 215)
            .frame(maxHeight: .infinity, alignment: .top)
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
}

struct ProfileView_Preview: PreviewProvider {
    
    @State static var screen: Screen = .profile
    
    static var previews: some View {
        ProfileView(screen: $screen)
    }
}

final class ProfileViewModel: ObservableObject {
    
    let dm: DataManager
    
    @Published var image: Data?
    @Published var name = ""
    @Published var surname = ""
    @Published var target = ""
    @Published var birthday = ""
    
    init(dm: DataManager) {
        self.dm = dm
    }
    
    func saveProfile() {
        dm.saveProfile(Profile(image: image, name: name, surname: surname, target: target, birthday: birthday))
    }
}
