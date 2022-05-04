

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

func setText(item: Int, currentEx: NSManagedObject) -> String{
    switch item{
    case 0:
        return caseDate(currentEx)
    case 1:
        return currentEx.value(forKey: "name") as? String ?? ""
    case 2:
        return String(currentEx.value(forKey: "rep") as? Int16 ?? 0)
    case 3:
        return String(currentEx.value(forKey: "reps") as? Int16 ?? 0)
    case 4:
        return String(currentEx.value(forKey: "weight") as? Int16 ?? 0)
    case 5:
        return String((currentEx.value(forKey: "weight") as? Int16 ?? 0) * (currentEx.value(forKey: "reps") as? Int16 ?? 0))
    
    default:
        return ""
    }
     
}

func caseDate(_ currentEx: NSManagedObject) -> String{
    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "dd.MM.YY"
    dateFormatter.dateFormat = "dd.MM.YY hh:mm:ss"
    let text = dateFormatter.string(from: (currentEx.value(forKey: "date") as! Date))
    return text
}
