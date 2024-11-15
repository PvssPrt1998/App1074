import SwiftUI

struct AchievementsView: View {
    
    @ObservedObject var viewModel = VMF.shared.achievementsViewModel()
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                Text("Achievements")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                
                content
                    .padding(.top, 26)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    private var content: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 30) {
                ForEach(viewModel.achievements, id: \.self) { ach in
                    VStack(spacing: 25) {
                        Image("athleteCup")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width - 108)
                            .frame(maxHeight: 376)
                            .clipShape(.rect(cornerRadius: 25))
                        Text(ach.blocked ? ach.lockedTitle : ach.title)
                            .font(.system(size: 25, weight: .medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .frame(width: UIScreen.main.bounds.width - 108, height: 90)

                        VStack(spacing: 10) {
                            Button {
                                viewModel.earn(ach)
                            } label: {
                                Text(ach.blocked ? "Blocked" : "Claim your prize")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(ach.blocked || ach.earned ? .white : .c546063)
                                    .frame(width: UIScreen.main.bounds.width - 168)
                                    .frame(height: 48)
                                    .background(ach.blocked || ach.earned ? Color.c646464 : Color.cPrimary)
                                    .clipShape(.rect(cornerRadius: 12))
                            }
                            .disabled(ach.blocked || ach.earned)
                            if !ach.earned && !ach.blocked {
                                HStack(spacing: 2) {
                                    Text("+\(ach.reward)")
                                        .font(.system(size: 24, weight: .regular))
                                        .foregroundColor(.white)
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 24, weight: .regular))
                                        .foregroundColor(.cPrimary)
                                }
                                .frame(height: 25)
                                .padding(.bottom, 8)
                            } else if ach.earned {
                                Text("You have already received your bonus")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.white)
                                    .frame(height: 25)
                                    .padding(.bottom, 8)
                            } else {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 20, height: 25)
                                    .padding(.bottom, 8)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 54)
        }
    }
}

#Preview {
    AchievementsView()
}
