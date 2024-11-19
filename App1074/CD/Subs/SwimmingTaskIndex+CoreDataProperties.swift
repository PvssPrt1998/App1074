import Foundation
import CoreData


extension SwimmingTaskIndex {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SwimmingTaskIndex> {
        return NSFetchRequest<SwimmingTaskIndex>(entityName: "SwimmingTaskIndex")
    }

    @NSManaged public var index: Int32

}

extension SwimmingTaskIndex : Identifiable {

}
