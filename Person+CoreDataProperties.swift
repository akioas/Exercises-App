

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var birthday: Date?
    @NSManaged public var height: Int16
    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var weight: Int16
    @NSManaged public var role: String?
    @NSManaged public var exerciseSet: NSSet?

}

// MARK: Generated accessors for exerciseSet
extension Person {

    @objc(addExerciseSetObject:)
    @NSManaged public func addToExerciseSet(_ value: ExerciseSet)

    @objc(removeExerciseSetObject:)
    @NSManaged public func removeFromExerciseSet(_ value: ExerciseSet)

    @objc(addExerciseSet:)
    @NSManaged public func addToExerciseSet(_ values: NSSet)

    @objc(removeExerciseSet:)
    @NSManaged public func removeFromExerciseSet(_ values: NSSet)

}

extension Person : Identifiable {

}
