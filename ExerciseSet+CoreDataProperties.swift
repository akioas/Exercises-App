

import Foundation
import CoreData


extension ExerciseSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseSet> {
        return NSFetchRequest<ExerciseSet>(entityName: "ExerciseSet")
    }

    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var set_number: Int16
    @NSManaged public var repeats: Int16
    @NSManaged public var weight: Double
    @NSManaged public var created_at: Date?
    @NSManaged public var distance: Int16
    @NSManaged public var duration: Int16
    @NSManaged public var calories: Int16
    @NSManaged public var person: Person?
    @NSManaged public var exercise: ExerciseSet?

}

extension ExerciseSet : Identifiable {

}
