

import Foundation
import CoreData




let context = AppDelegate().persistentContainer.viewContext


class DataModel{
    
    func addModel() -> ExerciseSet{
        let newItem = ExerciseSet(context: context)
        newItem.date = Date()
        newItem.name = NSLocalizedString("Exercise", comment: "")
        newItem.set_number = 0
        newItem.repeats = 10
        newItem.weight = 10.0
        newItem.person = fetchUser()
        saveModel()
        return newItem
    }
    
    func addUser() -> NSManagedObject{
        let newUser = Person(context: context)
        newUser.birthday = Date()
        newUser.name = NSLocalizedString("User", comment: "")
        newUser.gender = NSLocalizedString("Not set", comment: "")
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
    let sexKey = "gender"
    let weightKey = "weight"
    let heightKey = "height"

    let birthdayKey = "birthday"
   
    func wasLaunched(){
        UserDefaults.standard.set(true, forKey: "firstLaunch")
    }
    func isFirstLaunch() -> Bool{
        UserDefaults.standard.bool(forKey: "firstLaunch")
    }
}
