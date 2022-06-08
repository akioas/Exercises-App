

import Foundation
import CoreData




let context = AppDelegate().persistentContainer.viewContext


class DataModel{
    
    func addModel() -> ExerciseSet{
        let newItem = ExerciseSet(context: context)
        newItem.date = Date()
        newItem.exercise = ExercisesList().add()
        newItem.set_number = 0
        newItem.repeats = 10
        newItem.weight = 10.0
        newItem.person = fetchUser()
        newItem.created_at = Date()
        newItem.calories = 100
        newItem.duration = 30
        newItem.distance = 1.0

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
    var allExersisesCardio = [ NSLocalizedString("Leg abduction", comment: ""),
                         NSLocalizedString("Leg quadriceps", comment: ""),
                         NSLocalizedString("Back hyperextension", comment: "")]
    var allExercisesStrength = [
            NSLocalizedString("Bicep simulator", comment: ""),
            NSLocalizedString("Press simulator", comment: "")]
    func add() -> Exercise{
        let newEx = Exercise(context: context)
        newEx.name = NSLocalizedString("Exercise", comment: "")
        newEx.type = "Cardio"
        return newEx
    }
    func initFirst(){
        for exersise in allExersisesCardio {
            let newEx = Exercise(context: context)
            newEx.name = exersise
            newEx.type = "Cardio"
            DataModel().saveModel()

        }
        for exersise in allExercisesStrength {
            let newEx = Exercise(context: context)
            newEx.name = exersise
            newEx.type = "Strength"
            DataModel().saveModel()

        }
    }
    func save(_ strings: [String]){
        UserDefaults.standard.set(strings, forKey: "ex")
    }
    func saveRow(_ row: Int){
        UserDefaults.standard.set(row, forKey: "row")
    }
    func loadRow() -> Int?{
        UserDefaults.standard.integer(forKey: "row") 
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
