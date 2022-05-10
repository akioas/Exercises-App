

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
