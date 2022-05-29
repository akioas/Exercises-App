

import Foundation
import CoreData




let context = AppDelegate().persistentContainer.viewContext


class DataModel{
    
    func addModel() -> NSManagedObject{
        let newItem = Entity(context: context)
        newItem.date = Date()
        newItem.name = "Упражнение"
        newItem.rep = 0
        newItem.reps = 10
        newItem.weight = 10
        saveModel()
        return newItem
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
    var allExersises = [ "Отведение ног", "Квадрицепс ног",
                  "Бицепс тренажер", "Пресс тренажер",
                  "Спина гиперэкстензия"]
    
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
    let birthdayKey = "birthday"
    
    func save(_ name: String, forKey key: String){
        UserDefaults.standard.set(name, forKey: key)
    }
    func load(forKey key: String) -> String{
        UserDefaults.standard.string(forKey: key) ?? ""
    }
    func wasLaunched(){
        UserDefaults.standard.set(false, forKey: "firstLaunch")
    }
    func isFirstLaunch() -> Bool{
        UserDefaults.standard.bool(forKey: "firstLaunch")
    }
}
