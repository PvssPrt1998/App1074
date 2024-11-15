import Foundation
import CoreData


extension TotalTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TotalTime> {
        return NSFetchRequest<TotalTime>(entityName: "TotalTime")
    }

    @NSManaged public var time: Int32

}

extension TotalTime : Identifiable {

}
