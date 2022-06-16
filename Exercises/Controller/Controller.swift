import Foundation
import CoreData

func fetchRequest(isFiltered: Bool, date: Date) -> NSFetchRequest<ExerciseSet>{
    let fetchRequest = NSFetchRequest<ExerciseSet>(entityName: "ExerciseSet")
    if isFiltered{
        let (startDate, endDate) = dates(for: date)
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as CVarArg, endDate as CVarArg)
    }
    let sort = NSSortDescriptor(key: "date", ascending: false)
    fetchRequest.sortDescriptors = [sort]
    return fetchRequest
}

func deleteData(_ object: NSManagedObject){
    DataModel().delete(object)
}
