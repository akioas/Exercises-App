import Foundation
import CoreData


class Fetching {
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
    func fetchUser() -> Person?{
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        var person: Person? = nil
        do {
            let users = try context.fetch(fetchRequest)
            if let personNew = users.last{
                person = personNew
            }
            
        } catch let err as NSError {
            print(err)
        }
        return person
    }
    func dates(for date: Date) -> (start: Date, end: Date){
        let startDate = Calendar.current.startOfDay(for: date)
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let endDate = Calendar.current.date(byAdding: components, to: startDate)!
        return (startDate, endDate)
    }

}
class AppData {
    func deleteData(_ object: NSManagedObject){
        DataModel().delete(object)
        saveObjects()
    }
    func newExercise() -> ExerciseSet{
        DataModel().addModel()
    }
    func saveObjects(){
        DataModel().saveModel()
    }
}
class ExerciseTypes {
    let consts = SettingsData()
    func typesSave() -> [String]{
        return consts.typesSave
    }
    
    func typesShow() -> [String]{
        return consts.typesShow
    }
}

class GetExercises {
    let list = ExercisesList()
    func add() -> Exercise{
        list.add()
    }
    func saveStrength(object: ExerciseSet){
        list.saveRepNum(Int(object.set_number))
        list.saveRepsNum(Int(object.repeats))
        list.saveWeightNum(object.weight)
    }
    func saveCardio(object: ExerciseSet){
        list.saveCalNum(Int(object.calories))
        list.saveDurNum(Int(object.duration))
        list.saveDistNum(object.distance)
    }
    func saveRow(_ row: String){
        list.saveRow(row)
    }
    func loadRow() -> String?{
        list.loadRow()
    }
}
