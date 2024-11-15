import SwiftUI

struct ChallengesView: View {
    
    @State var completeAlert = false
    @State var selection = 0
    @ObservedObject var viewModel = VMF.shared.challengesViewModel()
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white.withAlphaComponent(0.1)
        UISegmentedControl.appearance().backgroundColor = UIColor(.c120120108.opacity(0.24))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                Text("Challenges")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                
                segmentedControl
                
                if selection == 0 {
                    all
                        .padding(.top, 42)
                } else {
                    accepted
                        .padding(.top, 42)
                }
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    private var segmentedControl: some View {
        Picker("",selection: $selection) {
            Text("All").tag(0)
            Text("Accepted").tag(1)
        }
        .pickerStyle(.segmented)
        .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16))
    }
    
    private var all: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 20),GridItem(.flexible())], spacing: 20) {
                ForEach(viewModel.challenges, id: \.self) { cha in
                    challengeCard(cha)
                        .opacity(cha.levelForUnlock > viewModel.dm.level ? 0.4 : 1)
                        .overlay(
                            VStack {
                                Image(systemName: "lock")
                                    .font(.system(size: 56, weight: .regular))
                                    .foregroundColor(.cPrimary)
                                Text("Get a \(cha.levelForUnlock) level")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .opacity(cha.levelForUnlock > viewModel.dm.level ? 1 : 0)
                            .padding(.bottom, 88)
                            ,alignment: .bottom
                        )
                }
            }
            .padding(.top, 1)
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
        }
    }
    
    private var accepted: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 20),GridItem(.flexible())], spacing: 20) {
                ForEach(viewModel.challenges.filter {$0.accepted && !$0.completed }, id: \.self) { cha in
                    challengeCard(cha)
                        .opacity(cha.levelForUnlock > viewModel.dm.level ? 0.4 : 1)
                        .overlay(
                            VStack {
                                Image(systemName: "lock")
                                    .font(.system(size: 56, weight: .regular))
                                    .foregroundColor(.cPrimary)
                                Text("Get a \(cha.levelForUnlock) level")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .opacity(cha.levelForUnlock > viewModel.dm.level ? 1 : 0)
                            .padding(.bottom, 88)
                            ,alignment: .bottom
                        )
                }
            }
            .padding(.top, 1)
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
        }
    }
    
    private func challengeCard(_ challenge: Challenge) -> some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text(challenge.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text(challenge.time)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            Text("\(challenge.points) points")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .padding(.top, 10)
            
            Button {
                if !challenge.accepted {
                    viewModel.accept(challenge)
                } else {
                    viewModel.complete(challenge)
                }
            } label: {
                Text(textForChallenge(challenge))
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(challenge.completed ? .white : .c546063)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(challenge.completed ? .c646464 : Color.cPrimary)
                    .clipShape(.rect(cornerRadius: 12))
            }
            .disabled(challenge.levelForUnlock > viewModel.dm.level || challenge.completed)
            .padding(.horizontal, 12)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .padding(.vertical, 28)
        .frame(height: 216)
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.cPrimary, lineWidth: 1)
        )
    }
    
    func textForChallenge(_ challenge: Challenge) -> String {
        if challenge.accepted && !challenge.completed {
            return "Complete"
        } else if challenge.completed {
            return "Completed"
        } else {
            return "Accept"
        }
    }
}

#Preview {
    ChallengesView()
}
