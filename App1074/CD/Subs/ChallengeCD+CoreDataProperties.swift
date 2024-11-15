import Foundation
import CoreData


extension ChallengeCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChallengeCD> {
        return NSFetchRequest<ChallengeCD>(entityName: "ChallengeCD")
    }

    @NSManaged public var accepted: Bool
    @NSManaged public var completed: Bool
    @NSManaged public var time: String
}

extension ChallengeCD : Identifiable {

}
