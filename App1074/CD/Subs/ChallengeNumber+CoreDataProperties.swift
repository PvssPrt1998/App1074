import Foundation
import CoreData


extension ChallengeNumber {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChallengeNumber> {
        return NSFetchRequest<ChallengeNumber>(entityName: "ChallengeNumber")
    }

    @NSManaged public var text: String

}

extension ChallengeNumber : Identifiable {

}
