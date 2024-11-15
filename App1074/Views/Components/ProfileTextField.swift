import SwiftUI

struct TextFieldCustom: View {
    
    @Binding var text: String
    
    var needPrefix: Bool = true
    let prefix: String
    let placeholder: String
    
    var body: some View {
        HStack(spacing: 10) {
            if needPrefix {
                Text(prefix)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.cPrimary)
            }
            TextField("", text: $text)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white)
                .autocorrectionDisabled(true)
                .accentColor(.white)
                .background(
                    placeholderView()
                )
        }
        .padding(.leading, 16)
        .frame(height: 44)
        .background(Color.white.opacity(0.05))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.c224231237, lineWidth: 1)
        )
        .clipShape(.rect(cornerRadius: 10))
    }
    
    @ViewBuilder func placeholderView() -> some View {
        Text(text != "" ? "" : placeholder)
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.c151151151)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CustomTF_Preview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        TextFieldCustom(text: $text, prefix: "Name", placeholder: "Name")
            .padding()
            .background(Color.bgMain)
    }
}
