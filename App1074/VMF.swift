import Foundation

final class VMF {
    
    let dm: DataManager = DataManager()
    
    private init() {}
    
    static let shared = VMF()
    
    func createProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(dm: dm)
    }
    
    func levelViewModel() -> LevelViewModel {
        LevelViewModel(dm: dm)
    }
    
    func trainingViewModel() -> TrainingViewModel {
        TrainingViewModel(dm: dm)
    }
    
    func challengesViewModel() -> ChallengesViewModel {
        ChallengesViewModel(dm: dm)
    }
    
    func achievementsViewModel() -> AchievementsViewModel {
        AchievementsViewModel(dm: dm)
    }
    
    func settingsViewModel() -> SettingsViewModel {
        SettingsViewModel(dm: dm)
    }
    func editProfileViewModel() -> EditProfileViewModel {
        EditProfileViewModel(dm: dm)
    }
}
