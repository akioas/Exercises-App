

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var rep: Int16
    @NSManaged public var reps: Int16
    @NSManaged public var weight: Double

}

extension Entity : Identifiable {

}
