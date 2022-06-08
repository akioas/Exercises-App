

import Foundation
import CoreData




let context = AppDelegate().persistentContainer.viewContext


class DataModel{
    
    func addModel() -> ExerciseSet{
        let newItem = ExerciseSet(context: context)
        newItem.date = Date()
        newItem.name = NSLocalizedString("Exercise", comment: "")
        newItem.rep = 0
        newItem.reps = 10
        newItem.weight = 10.0
        newItem.person = fetchUser()
        saveModel()
        return newItem
    }
    
    func addUser() -> NSManagedObject{
        let newUser = Person(context: context)
        newUser.birthday = Date()
        newUser.name = NSLocalizedString("User", comment: "")
        newUser.sex = NSLocalizedString("Not set", comment: "")
        newUser.weight = 0
        saveModel()
        return newUser
    }

    func saveModel(){
     
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func delete(_ object: NSManagedObject){
        context.delete(object)
        saveModel()
    }
    
}



class ExercisesList{
    var allExersises = [ NSLocalizedString("Отведение ног", comment: ""),
                         NSLocalizedString("Квадрицепс ног", comment: ""),
                         NSLocalizedString("Бицепс тренажер", comment: ""),
                         NSLocalizedString("Пресс тренажер", comment: ""),
                         NSLocalizedString("Спина гиперэкстензия", comment: "")]
    
    func load() -> [String]{
        UserDefaults.standard.array(forKey: "ex") as? [String] ?? allExersises
    }
    func save(_ strings: [String]){
        UserDefaults.standard.set(strings, forKey: "ex")

    }
}

class UserVariables{
    
    let nameKey = "name"
    let sexKey = "sex"
    let weightKey = "weight"
    let heightKey = "height"

    let birthdayKey = "birthday"
    /*
    func save(_ name: Any, forKey key: String){
        UserDefaults.standard.set(name, forKey: key)
    }
    func load(forKey key: String) -> String{
        if key == birthdayKey{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale.current)
            let date = (UserDefaults.standard.object(forKey: key)) as? Date ?? Date()
            if date == Date(){
                return "Not set"
            } else {
                return dateFormatter.string(from: date)
            }
        } else {
            return UserDefaults.standard.string(forKey: key) ?? ""
        }
    }
     */
    func wasLaunched(){
        UserDefaults.standard.set(true, forKey: "firstLaunch")
    }
    func isFirstLaunch() -> Bool{
        UserDefaults.standard.bool(forKey: "firstLaunch")
    }
}
