import SwiftUI

struct SwimmingView: View {
    
    @ObservedObject var viewModel: SwimmingViewModel = VMF.shared.swimmingViewModel()
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
                content
                    .padding(EdgeInsets(top: 17, leading: 16, bottom: 0, trailing: 16))
                Text(viewModel.isBreak ? "\(viewModel.breakMinutesLeft):\(viewModel.breakSecondsLeft)" : "\(viewModel.minutesLeft):\(viewModel.secondsLeft)")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.top, 25)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            VStack(spacing: 15) {
                if viewModel.endTraining {
                    Text("Completed")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(height: 48)
                } else {
                    Button {
                        if viewModel.isBreak {
                            viewModel.isBreak = false
                        } else {
                            viewModel.isBreak = true
                        }
                    } label: {
                        Text(viewModel.isBreak ? "Continue" : "Break")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(viewModel.isBreak ? .white : .c546063)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(viewModel.isBreak ? Color.bgSecond : Color.cSecondary)
                            .clipShape(.rect(cornerRadius: 16))
                    }
                    .disabled(viewModel.breakValue < 1)
                    .opacity(viewModel.breakValue < 1 ? 0.5 : 1)
                    .padding(.horizontal, 16)
                }
                
                Button {
                    viewModel.end()
                    show = false
                } label: {
                    Text("End")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.c546063)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.cSecondary)
                        .clipShape(.rect(cornerRadius: 16))
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .onReceive(viewModel.timer, perform: { _ in
            viewModel.strokeTimer()
        })
    }
    
    private var header: some View {
        Text("Task")
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.white)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .overlay(
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
                , alignment: .leading
            )
    }
    
    private var content: some View {
        VStack(spacing: 27) {
            Text(viewModel.currentTask.description)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 52)
                
            VStack(spacing: 10) {
                HStack(spacing: 5) {
                    Image("figureIndoor")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Exercise: " + viewModel.currentTask.name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                HStack(spacing: 5) {
                    Image(systemName: "clock")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.cSecondary)
                        .frame(width: 24, height: 24)
                    Text("Time: \(viewModel.currentTask.time) minutes")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                HStack(spacing: 5) {
                    Image("cup")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Break: \(viewModel.currentTask.taskBreak) minutes")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    
}

struct SwimmingView_Preview: PreviewProvider {
    
    @State static var show = true
    
    static var previews: some View {
        RunningView(show: $show)
    }
}

final class SwimmingViewModel: ObservableObject {
    
    let dm: DataManager
    
    @Published var timerValue: Int = 0
    @Published var breakValue: Int = 0
    @Published var endTraining = false
    @Published var currentTaskIndex: Int
    
    var currentTask: Task {
        dm.swimmingTasks[currentTaskIndex]
    }
    
    @Published var isBreak = false
    
    var minutesLeft: String {
        let minutes = timerValue / 60
        let string = "\(timerValue / 60)"
        if minutes < 10 {
            return "0" + string
        } else {
            return string
        }
    }
    
    var secondsLeft: String {
        let minutes = timerValue / 60
        let seconds = timerValue - (minutes * 60)
        if seconds < 10 {
            return "0" + "\(seconds)"
        } else {
            return "\(seconds)"
        }
    }
    
    var breakMinutesLeft: String {
        let minutes = breakValue / 60
        let string = "\(breakValue / 60)"
        if minutes < 10 {
            return "0" + string
        } else {
            return string
        }
    }
    
    var breakSecondsLeft: String {
        let minutes = breakValue / 60
        let seconds = breakValue - (minutes * 60)
        if seconds < 10 {
            return "0" + "\(seconds)"
        } else {
            return "\(seconds)"
        }
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(dm: DataManager) {
        self.dm = dm
        self.currentTaskIndex = dm.swimmingCurrentTaskIndex
        timerValue = currentTask.time * 60
        breakValue = currentTask.taskBreak * 60
    }
    
    func end() {
        dm.swimmingDone(currentTask.time * 60 - timerValue)
    }
    
    func strokeTimer() {
        if isBreak {
            if breakValue >= 1 {
                breakValue -= 1
            } else {
                isBreak = false
            }
        } else {
            if timerValue >= 1 {
                timerValue -= 1
            } else {
                endTraining = true
            }
        }
    }
}
