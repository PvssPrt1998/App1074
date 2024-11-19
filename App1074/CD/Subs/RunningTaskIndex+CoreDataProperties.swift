import Foundation
import CoreData


extension RunningTaskIndex {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RunningTaskIndex> {
        return NSFetchRequest<RunningTaskIndex>(entityName: "RunningTaskIndex")
    }

    @NSManaged public var index: Int32

}

extension RunningTaskIndex : Identifiable {

}
