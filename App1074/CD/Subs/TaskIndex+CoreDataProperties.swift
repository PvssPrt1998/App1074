import Foundation
import CoreData


extension TaskIndex {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskIndex> {
        return NSFetchRequest<TaskIndex>(entityName: "TaskIndex")
    }

    @NSManaged public var index: Int32

}

extension TaskIndex : Identifiable {

}
