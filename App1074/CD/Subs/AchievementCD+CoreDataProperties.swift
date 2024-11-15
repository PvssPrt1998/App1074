import Foundation
import CoreData


extension AchievementCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AchievementCD> {
        return NSFetchRequest<AchievementCD>(entityName: "AchievementCD")
    }

    @NSManaged public var earned: Bool
    @NSManaged public var title: String

}

extension AchievementCD : Identifiable {

}