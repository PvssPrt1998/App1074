import Foundation
import CoreData


extension ShowTraining {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShowTraining> {
        return NSFetchRequest<ShowTraining>(entityName: "ShowTraining")
    }

    @NSManaged public var show: Bool

}

extension ShowTraining : Identifiable {

}
