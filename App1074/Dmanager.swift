import Foundation

final class DataManager: ObservableObject {
    
    let loma = LoMa()
    
    var totalTime: Int = 0
    var loaded = false
    @Published var level = 1
    @Published var exp = 0
    
    @Published var currentTaskIndex = 0
    
    var tasks: Array<Task> = [
        Task(imageName: "PullUp", name: "Pull-up", time: 30, taskBreak: 10),
        Task(imageName: "LegExtension", name: "Leg extensions", time: 40, taskBreak: 10),
        Task(imageName: "RomanianRise", name: "Romanian rise", time: 30, taskBreak: 10),
        Task(imageName: "Deadlift", name: "Deadlift", time: 10, taskBreak: 10),
        Task(imageName: "DumpbellBenchPress", name: "Dumbbell Bench Press", time: 10, taskBreak: 10),
        Task(imageName: "Burpbell", name: "Barbell row to the chin", time: 15, taskBreak: 5),
        Task(imageName: "BenchCrunches", name: "Bench crunches", time: 15, taskBreak: 5),
        Task(imageName: "ReverseCrunches", name: "Reverse crunches", time: 20, taskBreak: 5),
        Task(imageName: "FrenchBenchPress", name: "French bench press", time: 20, taskBreak: 10),
        Task(imageName: "ArmCurl", name: "Arm Curl", time: 20, taskBreak: 10)
    ]
    
    @Published var challenges: Array<Challenge> = [
        Challenge(title: "Log into the app", time: "2 days in a row", points: 200, levelForUnlock: 1, accepted: false, completed: false),
        Challenge(title: "Log into the app", time: "4 days in a row", points: 200, levelForUnlock: 1, accepted: false, completed: false),
        Challenge(title: "Log into the app", time: "6 days in a row", points: 300, levelForUnlock: 2, accepted: false, completed: false),
        Challenge(title: "Log into the app", time: "8 days in a row", points: 300, levelForUnlock: 2, accepted: false, completed: false),
        Challenge(title: "Log into the app", time: "10 days in a row", points: 400, levelForUnlock: 3, accepted: false, completed: false),
        Challenge(title: "Exercise", time: "10 minutes a day", points: 400, levelForUnlock: 3, accepted: false, completed: false),
        Challenge(title: "Exercise", time: "15 minutes a day", points: 500, levelForUnlock: 4, accepted: false, completed: false),
        Challenge(title: "Exercise", time: "20 minutes a day", points: 500, levelForUnlock: 4, accepted: false, completed: false),
        Challenge(title: "Exercise", time: "25 minutes a day", points: 600, levelForUnlock: 5, accepted: false, completed: false),
        Challenge(title: "Exercise", time: "30 minutes a day", points: 600, levelForUnlock: 5, accepted: false, completed: false),
        Challenge(title: "do a workout", time: "outside 2 times", points: 700, levelForUnlock: 6, accepted: false, completed: false),
        Challenge(title: "do a workout", time: "outside 4 times", points: 700, levelForUnlock: 6, accepted: false, completed: false)
    ]
    
    @Published var achievements: Array<Achievement> = []
    
    @Published var profile: Profile?
    
    init() {
        setupAchievements()
    }
    
    func load() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            
            if let aCD = try? loma.fetchAchievements() {
                for i in 0..<achievements.count {
                    aCD.forEach { val in
                        if val.0 == self.achievements[i].title {
                            self.achievements[i].earned = val.1
                        }
                    }
                }
            }
            if let cCD = try? loma.fetchChallenge() {
                for i in 0..<challenges.count {
                    cCD.forEach { val in
                        if val.0 == self.challenges[i].time {
                            self.challenges[i].accepted = val.1
                            self.challenges[i].completed = val.2
                        }
                    }
                }
            }
            if let profileCD = try? loma.fetchProfile() {
                self.profile = profileCD
            }
            if let expCD = try? loma.fetchExp() {
                self.exp = expCD
            }
            if let lvlCD = try? loma.fetchLevel() {
                self.level = lvlCD
            }
            if let totalTimeCD = try? loma.fetchTotalTime() {
                self.totalTime = totalTimeCD
            }
            if let taskIndexCD = try? loma.fetchTaskIndex() {
                self.currentTaskIndex = taskIndexCD
            }
            
            DispatchQueue.main.async {
                self.loaded = true
            }
        }
    }
    
    func setupAchievements() {
        achievements = [
            Achievement(lockedTitle: "Reach level 5 to unlock", title: "Congratulations! You completed 5 levels! keep it up", reward: 100, blocked: level < 5, earned: false),
            Achievement(lockedTitle: "Reach level 10 to unlock", title: "Congratulations! You completed 10 levels! keep it up", reward: 120, blocked: level < 10, earned: false),
            Achievement(lockedTitle: "Reach level 15 to unlock", title: "Congratulations! You completed 15 levels! keep it up", reward: 130, blocked: level < 15, earned: false),
            Achievement(lockedTitle: "Reach level 20 to unlock", title: "Congratulations! You completed 20 levels! keep it up", reward: 150, blocked: level < 20, earned: false),
            Achievement(lockedTitle: "Reach level 25 to unlock", title: "Congratulations! You completed 25 levels! keep it up", reward: 150, blocked: level < 25, earned: false),
            Achievement(lockedTitle: "Train for at least 5 hours to unlock", title: "Congratulations!!!You trained for 5 hours! You are a real athlete", reward: 100, blocked: totalTime < 5 * 60 * 60, earned: false),
            Achievement(lockedTitle: "Train for at least 10 hours to unlock", title: "Congratulations!!!You trained for 10 hours! You are a real athlete", reward: 120, blocked: totalTime < 10 * 60 * 60, earned: false),
            Achievement(lockedTitle: "Train for at least 15 hours to unlock", title: "Congratulations!!!You trained for 15 hours! You are a real athlete", reward: 130, blocked: totalTime < 15 * 60 * 60, earned: false),
            Achievement(lockedTitle: "Train for at least 20 hours to unlock", title: "Congratulations!!!You trained for 20 hours! You are a real athlete", reward: 150, blocked: totalTime < 20 * 60 * 60, earned: false),
            Achievement(lockedTitle: "Train for at least 25 hours to unlock", title: "Congratulations!!!You trained for 25 hours! You are a real athlete", reward: 150, blocked: totalTime < 25 * 60 * 60, earned: false),
            Achievement(lockedTitle: "Unlock and complete your 1st challenge", title: "Congratulations!!!You have completed your 1st challenge! good work!", reward: 100, blocked: challenges.filter {$0.completed}.count >= 1, earned: false),
            Achievement(lockedTitle: "Unlock and complete your 3rd challenge", title: "Congratulations!!!You have completed your 3rd challenge! good work!", reward: 120, blocked: challenges.filter {$0.completed}.count >= 3, earned: false),
            Achievement(lockedTitle: "Unlock and complete your 6 challenge", title: "Congratulations!!!You have completed your 6 challenge! good work!", reward: 130, blocked: challenges.filter {$0.completed}.count >= 6, earned: false),
            Achievement(lockedTitle: "Unlock and complete your 9 challenge", title: "Congratulations!!!You have completed your 9 challenge! good work!", reward: 150, blocked: challenges.filter {$0.completed}.count >= 9, earned: false),
            Achievement(lockedTitle: "Unlock and complete your 12 challenge", title: "Congratulations!!!You have completed your 12 challenge! good work!", reward: 150, blocked: challenges.filter {$0.completed}.count >= 12, earned: false)
        ]
    }
    
    func accept(_ challenge: Challenge) {
        guard let index = challenges.firstIndex(where: {$0.time == challenge.time}) else { return }
        challenges[index].accepted = true
        loma.saveChallenge(challenges[index])
    }
    
    func complete(_ challenge: Challenge) {
        guard let index = challenges.firstIndex(where: {$0.time == challenge.time}) else { return }
        challenges[index].completed = true
        increaseExp(challenges[index].points)
        loma.saveExp(exp)
        loma.saveLevel(level)
        loma.saveChallenge(challenges[index])
    }
    
    func saveProfile(_ profile: Profile) {
        self.profile = profile
        loma.saveProfile(profile)
    }
    
    func trainingDone(_ trainingTime: Int) {
        totalTime += trainingTime
        loma.saveTotalTime(totalTime)
        exp += 100
        if exp >= 6000 {
            level += 1
            let ost = exp - 6000
            exp = ost
        }
        loma.saveExp(exp)
        loma.saveLevel(level)
        if currentTaskIndex == tasks.count - 1 {
            currentTaskIndex = 0
        } else {
            currentTaskIndex += 1
        }
        loma.saveTaskIndex(currentTaskIndex)
    }
    
    func increaseExp(_ value: Int) {
        exp += value
        if exp >= 6000 {
            level += 1
            let ost = exp - 6000
            exp = ost
        }
    }
    
    func earn(_ achievement: Achievement) {
        guard let index = achievements.firstIndex(where: {$0.title == achievement.title}) else { return }
        achievements[index].earned = true
        increaseExp(achievements[index].reward)
        loma.saveExp(exp)
        loma.saveLevel(level)
        loma.saveAchievement(achievements[index])
    }
}
