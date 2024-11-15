import Foundation
import CoreData


extension Exp {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exp> {
        return NSFetchRequest<Exp>(entityName: "Exp")
    }

    @NSManaged public var exp: Int32

}

extension Exp : Identifiable {

}
