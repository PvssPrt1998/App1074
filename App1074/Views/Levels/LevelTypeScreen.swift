import SwiftUI

struct LevelTypeScreen: View {
    
    @Binding var show: Bool
    @Binding var levelType: LevelType
    var types = ["Running", "Tripod hall", "Swimming pool"]
    @State var type = "Tripod hall"
    
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
                Picker("", selection: $type) {
                    ForEach(types, id: \.self) {
                                        Text($0)
                                    }
                            }
                .pickerStyle(.wheel)
                .labelsHidden()
                .frame(height: 212)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    private var header: some View {
        Text("Exercise type")
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
                        if type == "Tripod hall" {
                            levelType = .tripod
                        } else if type == "Running" {
                            levelType = .running
                        } else {
                            levelType = .swimming
                        }
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

struct LevelTypeScreen_Preview: PreviewProvider {
    @State static var show: Bool = true
    @State static var levelType: LevelType = .tripod
    
    static var previews: some View {
        LevelTypeScreen(show: $show, levelType: $levelType)
    }
}
