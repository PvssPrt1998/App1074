import SwiftUI
import Combine

struct LevelView: View {
    
    @ObservedObject var viewModel = VMF.shared.levelViewModel()
    
    @State var showTraining = false
    @State var showSwimming = false
    @State var showRunning = false
    @State var showPicker = false
    @State var levelType: LevelType = .tripod
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    header
                    levelBar
                    Button {
                        showPicker = true
                    } label: {
                        HStack {
                            Text(levelTypeText(levelType))
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            Image(systemName: "arrowtriangle.down.fill")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 20)
                    if levelType == .tripod {
                        exc
                    } else if levelType == .swimming {
                        excS
                    } else {
                        excR
                    }
                    
                    //.frame(maxHeight: .infinity, alignment: .top)
                }
                .padding(.bottom, 100)
                //.frame(maxHeight: .infinity, alignment: .top)
            }
            
            Button {
                switch levelType {
                case .tripod:
                    showTraining = true
                case .swimming:
                    showSwimming = true
                case .running:
                    showRunning = true
                }
                
            } label: {
                Text("Start")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.c546063)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.cSecondary)
                    .clipShape(.rect(cornerRadius: 16))
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .sheet(isPresented: $showTraining, content: {
            TrainingView(show: $showTraining)
        })
        .sheet(isPresented: $showSwimming, content: {
            SwimmingView(show: $showSwimming)
        })
        .sheet(isPresented: $showRunning, content: {
            RunningView(show: $showRunning)
        })
        .sheet(isPresented: $showPicker, content: {
            LevelTypeScreen(show: $showPicker, levelType: $levelType)
        })
    }
    
    private func levelTypeText(_ levelType: LevelType) -> String {
        switch levelType {
        case .tripod: return "Tripod hall"
        case .swimming: return "Swimming pool"
        case .running: return "Running"
        }
    }
    
    var lineWidth: CGFloat {
        return Double(viewModel.exp) / Double(6000) * UIScreen.main.bounds.width - 40
    }
    
    private var header: some View {
        HStack(spacing: 22) {
            if let data = viewModel.profile?.image {
                setImage(data)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 117, height: 133)
                    .clipped()
                    .background(Color.c151151151)
                    .clipShape(.rect(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white, lineWidth: 1)
                    )
                
            } else {
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .frame(width: 117, height: 133)
                    .background(Color.c157157157)
                    .clipShape(.rect(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white, lineWidth: 1)
                    )
            }
            
            
            VStack(spacing: 12) {
                Text("You’re almost\nthere!")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Level \(viewModel.level)")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(6000 - viewModel.exp) Points to next level")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white.opacity(0.3))
                }
               
            }
        }
        .padding(EdgeInsets(top: 36, leading: 30, bottom: 0, trailing: 30))
    }
    private var levelBar: some View {
        ZStack {
            Color.cSecondary.opacity(0.25)
                .clipShape(.rect(cornerRadius: 130))
            
            RoundedRectangle(cornerRadius: 90)
                .fill(Color.cPrimary)
                .frame(width: max(30,min(1, Double(viewModel.exp) / Double(6000)) * UIScreen.main.bounds.width - 40), height: 30)
                .overlay(
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.c546063.opacity(0.6))
                        (
                            Text("\(viewModel.exp)")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.c546063.opacity(0.8))
                            + Text("/6000")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.c546063.opacity(0.8))
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(width: 110)
                    .padding(.trailing, lineWidth > UIScreen.main.bounds.width - 70 ? 34 : 14 )
                    .opacity(lineWidth < 152 ? 0 : 1)
                    ,alignment: .trailing
                )
                .padding(.horizontal, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Circle()
                .fill(.cPrimary)
                .frame(width: 30, height: 30)
                .overlay(
                    Text("\(viewModel.level)")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.c546063)
                )
                .padding(.leading, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Circle()
                .fill(.white.opacity(0.5))
                .frame(width: 30, height: 30)
                .overlay(
                    Text("\(viewModel.level + 1)")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.c546063)
                )
                .padding(.trailing, 4)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
                (
                    Text("\(viewModel.exp)")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white)
                    + Text("/6000")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(width: 110)
            .opacity(lineWidth < 152 ? 1 : 0)
            .padding(.leading, 42)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 37)
        .padding(EdgeInsets(top: 18, leading: 16, bottom: 0, trailing: 16))
    }
    private var exc: some View {
        ZStack {
            HStack(spacing: 50) {
                Circle()
                    .fill(Color.c255253206)
                    .frame(width: 128, height: 128)
                    .overlay(
                        Text("\(viewModel.leftMoon)")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(.c203201140)
                    )
                    .shadow(color: .c255252183,radius: 12)
                    .overlay(Color.black.opacity(0.5).clipShape(.circle))
                    .frame(maxHeight: .infinity, alignment: .bottom)
                Circle()
                    .fill(Color.c255253206)
                    .frame(width: 180, height: 180)
                    .overlay(
                        Text("\(viewModel.currentTaskIndex + 1)")
                            .font(.system(size: 96, weight: .bold))
                            .foregroundColor(.c203201140)
                    )
                    .shadow(color: .c255252183,radius: 12)
                    .frame(maxHeight: .infinity, alignment: .top)
                    
                Circle()
                    .fill(Color.c255253206)
                    .frame(width: 128)
                    .overlay(
                        Text("\(viewModel.rightMoon)")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(.c203201140)
                    )
                    .shadow(color: .c255252183,radius: 12)
                    .overlay(Color.black.opacity(0.5).clipShape(.circle))
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .frame(width: UIScreen.main.bounds.width, height: 260)
            //.padding(.top, 20)
            
            VStack {
                HStack(spacing: 5) {
                    Image("figureIndoor")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Exercise: " + viewModel.currentTask.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 5) {
                    Image(systemName: "clock")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.cSecondary)
                        .frame(width: 24, height: 24)
                    Text("Time: \(viewModel.currentTask.time) minutes")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
                HStack(spacing: 5) {
                    Image("cup")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Break: \(viewModel.currentTask.taskBreak) minutes")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 220)
        }
    }
    private var excS: some View {
        ZStack {
            HStack(spacing: 50) {
                Circle()
                    .fill(Color.c255253206)
                    .frame(width: 128, height: 128)
                    .overlay(
                        Text("\(viewModel.sLeftMoon)")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(.c203201140)
                    )
                    .shadow(color: .c255252183,radius: 12)
                    .overlay(Color.black.opacity(0.5).clipShape(.circle))
                    .frame(maxHeight: .infinity, alignment: .bottom)
                Circle()
                    .fill(Color.c255253206)
                    .frame(width: 180, height: 180)
                    .overlay(
                        Text("\(viewModel.swimmingTaskIndex + 1)")
                            .font(.system(size: 96, weight: .bold))
                            .foregroundColor(.c203201140)
                    )
                    .shadow(color: .c255252183,radius: 12)
                    .frame(maxHeight: .infinity, alignment: .top)
                    
                Circle()
                    .fill(Color.c255253206)
                    .frame(width: 128)
                    .overlay(
                        Text("\(viewModel.sRightMoon)")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(.c203201140)
                    )
                    .shadow(color: .c255252183,radius: 12)
                    .overlay(Color.black.opacity(0.5).clipShape(.circle))
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .frame(width: UIScreen.main.bounds.width, height: 260)
            //.padding(.top, 20)
            
            VStack {
                HStack(spacing: 5) {
                    Image("figureIndoor")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Exercise: " + viewModel.swimmingTask.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 5) {
                    Image(systemName: "clock")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.cSecondary)
                        .frame(width: 24, height: 24)
                    Text("Time: \(viewModel.swimmingTask.time) minutes")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
                HStack(spacing: 5) {
                    Image("cup")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Break: \(viewModel.swimmingTask.taskBreak) minutes")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 220)
        }
    }
    private var excR: some View {
        ZStack {
            HStack(spacing: 50) {
                Circle()
                    .fill(Color.c255253206)
                    .frame(width: 128, height: 128)
                    .overlay(
                        Text("\(viewModel.rLeftMoon)")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(.c203201140)
                    )
                    .shadow(color: .c255252183,radius: 12)
                    .overlay(Color.black.opacity(0.5).clipShape(.circle))
                    .frame(maxHeight: .infinity, alignment: .bottom)
                Circle()
                    .fill(Color.c255253206)
                    .frame(width: 180, height: 180)
                    .overlay(
                        Text("\(viewModel.runningTaskIndex + 1)")
                            .font(.system(size: 96, weight: .bold))
                            .foregroundColor(.c203201140)
                    )
                    .shadow(color: .c255252183,radius: 12)
                    .frame(maxHeight: .infinity, alignment: .top)
                    
                Circle()
                    .fill(Color.c255253206)
                    .frame(width: 128)
                    .overlay(
                        Text("\(viewModel.rRightMoon)")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(.c203201140)
                    )
                    .shadow(color: .c255252183,radius: 12)
                    .overlay(Color.black.opacity(0.5).clipShape(.circle))
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .frame(width: UIScreen.main.bounds.width, height: 260)
            //.padding(.top, 20)
            
            VStack {
                HStack(spacing: 5) {
                    Image("figureIndoor")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Exercise: " + viewModel.runningTask.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 5) {
                    Image(systemName: "clock")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.cSecondary)
                        .frame(width: 24, height: 24)
                    Text("Time: \(viewModel.runningTask.time) minutes")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
                HStack(spacing: 5) {
                    Image("cup")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Break: \(viewModel.runningTask.taskBreak) minutes")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 220)
        }
    }
    
    private func setImage(_ data: Data?) -> Image {
        guard let data = data,
            let image = UIImage(data: data) else {
            return Image(systemName: "camera.fill")
        }
        return Image(uiImage: image)
    }
    
    
}

#Preview {
    LevelView()
}

final class LevelViewModel: ObservableObject {
    
    let dm: DataManager
    
    @Published var level: Int
    @Published var exp: Int
    @Published var profile: Profile?
    @Published var currentTaskIndex: Int
    @Published var swimmingTaskIndex: Int
    @Published var runningTaskIndex: Int
    
    var currentTask: Task {
        dm.tasks[currentTaskIndex]
    }
    var swimmingTask: Task {
        dm.swimmingTasks[swimmingTaskIndex]
    }
    var runningTask: Task {
        dm.runningTasks[runningTaskIndex]
    }
    
    var leftMoon: Int {
        if currentTaskIndex == 0 {
            return dm.tasks.count
        } else {
            return currentTaskIndex
        }
    }
    
    var rightMoon: Int {
        if currentTaskIndex == dm.tasks.count - 1 {
            return 1
        } else {
            return currentTaskIndex + 2
        }
    }
    
    var sLeftMoon: Int {
        if swimmingTaskIndex == 0 {
            return dm.swimmingTasks.count
        } else {
            return swimmingTaskIndex
        }
    }
    
    var sRightMoon: Int {
        if swimmingTaskIndex == dm.swimmingTasks.count - 1 {
            return 1
        } else {
            return swimmingTaskIndex + 2
        }
    }
    var rLeftMoon: Int {
        if runningTaskIndex == 0 {
            return dm.runningTasks.count
        } else {
            return runningTaskIndex
        }
    }
    
    var rRightMoon: Int {
        if runningTaskIndex == dm.runningTasks.count - 1 {
            return 1
        } else {
            return runningTaskIndex + 2
        }
    }
    
    private var currentTaskIndexCancellable: AnyCancellable?
    private var swimmingTaskIndexCancellable: AnyCancellable?
    private var runningTaskIndexCancellable: AnyCancellable?
    private var expCancellable: AnyCancellable?
    private var levelCancellable: AnyCancellable?
    private var profileCancellable: AnyCancellable?
    
    init(dm: DataManager) {
        self.dm = dm
        level = dm.level
        exp = dm.exp
        profile = dm.profile
        self.currentTaskIndex = dm.currentTaskIndex
        self.swimmingTaskIndex = dm.swimmingCurrentTaskIndex
        self.runningTaskIndex = dm.runningCurrentTaskIndex
        
        currentTaskIndexCancellable = dm.$currentTaskIndex.sink { [weak self] value in
            self?.currentTaskIndex = value
        }
        swimmingTaskIndexCancellable = dm.$swimmingCurrentTaskIndex.sink { [weak self] value in
            self?.swimmingTaskIndex = value
        }
        runningTaskIndexCancellable = dm.$runningCurrentTaskIndex.sink { [weak self] value in
            self?.runningTaskIndex = value
        }
        expCancellable = dm.$exp.sink { [weak self] value in
            self?.exp = value
        }
        levelCancellable = dm.$level.sink { [weak self] value in
            self?.level = value
        }
        profileCancellable = dm.$profile.sink { [weak self] value in
            self?.profile = value
        }
    }
}

enum LevelType {
    case tripod
    case swimming
    case running
}
