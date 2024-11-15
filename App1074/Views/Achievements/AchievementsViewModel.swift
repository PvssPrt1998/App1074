import Foundation
import Combine

final class AchievementsViewModel: ObservableObject {
    
    let dm: DataManager
    
    @Published var achievements: Array<Achievement>
    private var achievementsCancellable: AnyCancellable?
    
    init(dm: DataManager) {
        self.dm = dm
        achievements = dm.achievements
        
        achievementsCancellable = dm.$achievements.sink { [weak self] value in
            self?.achievements = value
        }
    }
    
    func earn(_ achievement: Achievement) {
        dm.earn(achievement)
    }
}
