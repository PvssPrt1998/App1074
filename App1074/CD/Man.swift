import Foundation

final class LoMa {
    private let modelName = "Mode"
    
    lazy var coreDataStack = CoreDataStack(modelName: modelName)
    
    func saveExp(_ exp: Int) {
        do {
            let expsCD = try coreDataStack.managedContext.fetch(Exp.fetchRequest())
            if expsCD.count > 0 {
                //exists
                expsCD[0].exp = Int32(exp)
            } else {
                let expCD = Exp(context: coreDataStack.managedContext)
                expCD.exp = Int32(exp)
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchExp() throws -> Int? {
        guard let expCD = try coreDataStack.managedContext.fetch(Exp.fetchRequest()).first else { return nil }
        return Int(expCD.exp)
    }
    func saveTotalTime(_ totalTime: Int) {
        do {
            let expsCD = try coreDataStack.managedContext.fetch(TotalTime.fetchRequest())
            if expsCD.count > 0 {
                //exists
                expsCD[0].time = Int32(totalTime)
            } else {
                let expCD = TotalTime(context: coreDataStack.managedContext)
                expCD.time = Int32(totalTime)
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchTotalTime() throws -> Int? {
        guard let expCD = try coreDataStack.managedContext.fetch(TotalTime.fetchRequest()).first else { return nil }
        return Int(expCD.time)
    }
    func saveLevel(_ exp: Int) {
        do {
            let expsCD = try coreDataStack.managedContext.fetch(Level.fetchRequest())
            if expsCD.count > 0 {
                //exists
                expsCD[0].level = Int32(exp)
            } else {
                let expCD = Level(context: coreDataStack.managedContext)
                expCD.level = Int32(exp)
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchLevel() throws -> Int? {
        guard let expCD = try coreDataStack.managedContext.fetch(Level.fetchRequest()).first else { return nil }
        return Int(expCD.level)
    }
    func saveTaskIndex(_ exp: Int) {
        do {
            let expsCD = try coreDataStack.managedContext.fetch(TaskIndex.fetchRequest())
            if expsCD.count > 0 {
                //exists
                expsCD[0].index = Int32(exp)
            } else {
                let expCD = TaskIndex(context: coreDataStack.managedContext)
                expCD.index = Int32(exp)
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchTaskIndex() throws -> Int? {
        guard let expCD = try coreDataStack.managedContext.fetch(TaskIndex.fetchRequest()).first else { return nil }
        return Int(expCD.index)
    }
    func saveSwimmingTaskIndex(_ exp: Int) {
        do {
            let expsCD = try coreDataStack.managedContext.fetch(SwimmingTaskIndex.fetchRequest())
            if expsCD.count > 0 {
                //exists
                expsCD[0].index = Int32(exp)
            } else {
                let expCD = SwimmingTaskIndex(context: coreDataStack.managedContext)
                expCD.index = Int32(exp)
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchSwimmingTaskIndex() throws -> Int? {
        guard let expCD = try coreDataStack.managedContext.fetch(SwimmingTaskIndex.fetchRequest()).first else { return nil }
        return Int(expCD.index)
    }
    func saveRunningTaskIndex(_ exp: Int) {
        do {
            let expsCD = try coreDataStack.managedContext.fetch(RunningTaskIndex.fetchRequest())
            if expsCD.count > 0 {
                //exists
                expsCD[0].index = Int32(exp)
            } else {
                let expCD = RunningTaskIndex(context: coreDataStack.managedContext)
                expCD.index = Int32(exp)
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchRunningTaskIndex() throws -> Int? {
        guard let expCD = try coreDataStack.managedContext.fetch(RunningTaskIndex.fetchRequest()).first else { return nil }
        return Int(expCD.index)
    }
    
    func saveAchievement(_ achievement: Achievement) {
        do {
            let expsCD = try coreDataStack.managedContext.fetch(AchievementCD.fetchRequest())
            var founded = false
            expsCD.forEach { aCD in
                if aCD.title == achievement.title {
                    founded = true
                    aCD.earned = achievement.earned
                }
            }
            if !founded {
                let aCD = AchievementCD(context: coreDataStack.managedContext)
                aCD.title = achievement.title
                aCD.earned = achievement.earned
            }
            
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchAchievements() throws -> Array<(String, Bool)> {
        var array: Array<(String, Bool)> = []
        let achsCD = try coreDataStack.managedContext.fetch(AchievementCD.fetchRequest())
        achsCD.forEach { acd in
            array.append((acd.title, acd.earned))
        }
        return array
    }
    
    func saveChallenge(_ challenge: Challenge) {
        print(challenge.completed)
        do {
            let expsCD = try coreDataStack.managedContext.fetch(ChallengeCD.fetchRequest())
            var founded = false
            expsCD.forEach { aCD in
                if aCD.time == challenge.time {
                    founded = true
                    aCD.accepted = challenge.accepted
                    aCD.completed = challenge.completed
                }
            }
            if !founded {
                let aCD = ChallengeCD(context: coreDataStack.managedContext)
                aCD.time = challenge.time
                aCD.accepted = challenge.accepted
                aCD.completed = challenge.completed
            }
            
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchChallenge() throws -> Array<(String, Bool, Bool)> {
        var array: Array<(String, Bool, Bool)> = []
        let achsCD = try coreDataStack.managedContext.fetch(ChallengeCD.fetchRequest())
        achsCD.forEach { acd in
            array.append((acd.time, acd.accepted, acd.completed))
        }
        return array
    }
    
    func saveProfile(_ profile: Profile) {
        do {
            let expsCD = try coreDataStack.managedContext.fetch(ProfileCD.fetchRequest())
            if expsCD.count > 0 {
                //exists
                expsCD[0].image = profile.image
                expsCD[0].name = profile.name
                expsCD[0].surname = profile.surname
                expsCD[0].target = profile.target
                expsCD[0].birthday = profile.birthday
            } else {
                let expCD = ProfileCD(context: coreDataStack.managedContext)
                expCD.image = profile.image
                expCD.name = profile.name
                expCD.surname = profile.surname
                expCD.target = profile.target
                expCD.birthday = profile.birthday
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchProfile() throws -> Profile? {
        guard let profile = try coreDataStack.managedContext.fetch(ProfileCD.fetchRequest()).first else { return nil }
        return Profile(image: profile.image, name: profile.name, surname: profile.surname, target: profile.target, birthday: profile.birthday)
    }
    
    func saveShowTraining(_ show: Bool) {
        do {
            let ids = try coreDataStack.managedContext.fetch(ShowTraining.fetchRequest())
            if ids.count > 0 {
                //exists
                ids[0].show = show
            } else {
                let showStatCD = ShowTraining(context: coreDataStack.managedContext)
                showStatCD.show = show
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchShowTraining() throws -> Bool? {
        guard let showStatCD = try coreDataStack.managedContext.fetch(ShowTraining.fetchRequest()).first else { return nil }
        return showStatCD.show
    }
    
    func fetchTrainingDescr() throws -> String? {
        guard let appText = try coreDataStack.managedContext.fetch(ChallengeNumber.fetchRequest()).first else { return nil }
        return appText.text
    }
    
    func trainingDescr() {
        let appText = ChallengeNumber(context: coreDataStack.managedContext)
        coreDataStack.saveContext()
    }
}
