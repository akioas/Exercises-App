

import Foundation
import CoreData


extension ExerciseSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseSet> {
        return NSFetchRequest<ExerciseSet>(entityName: "ExerciseSet")
    }

    @NSManaged public var calories: Int16
    @NSManaged public var created_at: Date?
    @NSManaged public var date: Date?
    @NSManaged public var distance: Double
    @NSManaged public var duration: Int16
    @NSManaged public var repeats: Int16
    @NSManaged public var set_number: Int16
    @NSManaged public var weight: Double
    @NSManaged public var exercise: Exercise?
    @NSManaged public var person: Person?

}

extension ExerciseSet : Identifiable {

}
