import Foundation

final class DataManager: ObservableObject {
    
    let loma = LoMa()
    
    var totalTime: Int = 0
    var loaded = false
    @Published var level = 1
    @Published var exp = 0
    
    @Published var currentTaskIndex = 0
    @Published var swimmingCurrentTaskIndex = 0
    @Published var runningCurrentTaskIndex = 0
    
    var tasks: Array<Task> = [
        Task(description: "A lower-body exercise where you bend your knees and hips to lower your body, then return to standing. Strengthens legs, glutes, and core.", name: "Pull-up", time: 30, taskBreak: 10),
        Task(description: "Leg Extensions: A seated exercise where you straighten your knees against resistance to target the quadriceps.", name: "Leg extensions", time: 40, taskBreak: 10),
        Task(description: "Romanian Deadlift: A hip-hinge exercise where you lower a weight while keeping your back straight, targeting hamstrings, glutes, and lower back.", name: "Romanian rise", time: 30, taskBreak: 10),
        Task(description: "Deadlift: A full-body exercise where you lift a weight from the ground to standing, targeting back, legs, and core.", name: "Deadlift", time: 10, taskBreak: 10),
        Task(description: "Dumbbell Bench Press: A chest exercise where you press dumbbells upward while lying on a bench, targeting chest, shoulders, and triceps.", name: "Dumbbell Bench Press", time: 10, taskBreak: 10),
        Task(description: "Barbell Row to Chin: A pulling exercise where you row a barbell to your chin, targeting upper back, shoulders, and biceps.", name: "Barbell row to the chin", time: 15, taskBreak: 5),
        Task(description: "Bench Crunches: An ab exercise where you curl your torso toward your knees while lying on a bench, targeting the core.", name: "Bench crunches", time: 15, taskBreak: 5),
        Task(description: "Reverse Crunches: A core exercise where you lift your hips and legs toward your chest, targeting the lower abs.", name: "Reverse crunches", time: 20, taskBreak: 5),
        Task(description: "French Bench Press: A tricep exercise where you lower a barbell or dumbbells behind your head while lying on a bench, then press back up.", name: "French bench press", time: 20, taskBreak: 10),
        Task(description: "Arm Curl: A bicep exercise where you lift a weight by bending your elbow, targeting the upper arm muscles.", name: "Arm Curl", time: 20, taskBreak: 10)
    ]
    
    var swimmingTasks: Array<Task> = [
        Task(description: "Butterfly (Dolphin): A swimming stroke where you move both arms simultaneously in a circular motion while kicking with both legs, resembling a dolphin's movement.", name: "Butterfly swimming", time: 40, taskBreak: 10),
        Task(description: "Backstroke: A swimming stroke where you lie on your back and alternate arm movements while kicking to move forward.", name: "Backstroke", time: 10, taskBreak: 10),
        Task(description: "Breaststroke: A swimming style where you move your arms in a half-circle while pulling your legs in a frog kick, focusing on rhythm and technique.", name: "Breaststroke", time: 30, taskBreak: 10),
        Task(description: "Freestyle (Front Crawl): A swimming stroke where you alternate arm movements while kicking, focusing on speed and endurance.", name: "Freestyle", time: 50, taskBreak: 10),
        Task(description: "Individual Medley (IM) Swimming: A swimming event that combines all four strokes—butterfly, backstroke, breaststroke, and freestyle—in a set order.", name: "Individual Medley", time: 40, taskBreak: 10)
    ]
    var runningTasks: Array<Task> = [
        Task(description: "Long-Distance Running: Running over extended distances to build endurance and cardiovascular fitness.", name: "Long-Distance", time: 40, taskBreak: 10),
        Task(description: "Relays: A team race where runners pass a baton to the next runner in a designated sequence.", name: "Relays", time: 10, taskBreak: 10),
        Task(description: "Hurdle Race: Running while jumping over obstacles (hurdles), focusing on speed, agility, and coordination.", name: "Hurdle Race", time: 10, taskBreak: 10),
        Task(description: "CrossFit: A high-intensity workout combining weightlifting, cardio, and bodyweight exercises for overall fitness.", name: "CrossFit", time: 10, taskBreak: 10),
        Task(description: "Road Running: Running on paved surfaces like streets or highways, focusing on endurance and speed.", name: "Road Running", time: 40, taskBreak: 10)
    ]
    
    
    @Published var challenges: Array<Challenge> = [
        Challenge(title: "Log into the app", time: "2 days in a row", points: 200, levelForUnlock: 1, accepted: false, completed: false),
        Challenge(title: "Log into the app", time: "4 days in a row", points: 200, levelForUnlock: 1, accepted: false, completed: false),
        Challenge(title: "Log into the app", time: "6 days in a row", points: 300, levelForUnlock: 2, accepted: false, completed: false),
        Challenge(title: "Run 2 marathons", time: "2 times a week", points: 300, levelForUnlock: 2, accepted: false, completed: false),//
        Challenge(title: "swims 4 km", time: "2 times a week", points: 300, levelForUnlock: 2, accepted: false, completed: false),//
        Challenge(title: "Log into the app", time: "8 days in a row", points: 300, levelForUnlock: 2, accepted: false, completed: false),
        Challenge(title: "Run 4 marathons", time: "4 times a week", points: 400, levelForUnlock: 3, accepted: false, completed: false),//
        Challenge(title: "swims 8 km", time: "1 times a week", points: 400, levelForUnlock: 3, accepted: false, completed: false),//
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
            if let taskIndexCD = try? loma.fetchSwimmingTaskIndex() {
                self.swimmingCurrentTaskIndex = taskIndexCD
            }
            if let taskIndexCD = try? loma.fetchRunningTaskIndex() {
                self.runningCurrentTaskIndex = taskIndexCD
                print(runningCurrentTaskIndex)
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
    func swimmingDone(_ trainingTime: Int) {
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
        if swimmingCurrentTaskIndex == swimmingTasks.count - 1 {
            swimmingCurrentTaskIndex = 0
        } else {
            swimmingCurrentTaskIndex += 1
        }
        loma.saveSwimmingTaskIndex(swimmingCurrentTaskIndex)
    }
    func runningDone(_ trainingTime: Int) {
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
        if runningCurrentTaskIndex == runningTasks.count - 1 {
            runningCurrentTaskIndex = 0
        } else {
            runningCurrentTaskIndex += 1
        }
        loma.saveRunningTaskIndex(runningCurrentTaskIndex)
        print(runningCurrentTaskIndex)
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
