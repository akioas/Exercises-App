

import Foundation
import CoreData




let context = AppDelegate().persistentContainer.viewContext


class DataModel{
    
    var exersizes = [ "Отведение ног", "Квадрицепс ног",
                      "Бицепс тренажер", "Пресс тренажер",
                      "Спина гиперэкстензия"]
    

    func addModel(){
        let newItem = Entity(context: context)
        newItem.date = Date()
        newItem.name = "Упражнение"
        newItem.rep = 0
        newItem.reps = 10
        newItem.weight = 10
        saveModel()
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



