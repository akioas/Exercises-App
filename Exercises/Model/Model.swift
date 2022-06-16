

import Foundation
import CoreData

let context = AppDelegate().persistentContainer.viewContext


class DataModel{
    let list = ExercisesList()
    func addModel() -> ExerciseSet{
        let newItem = ExerciseSet(context: context)
        newItem.date = Date()
        newItem.created_at = Date()
        newItem.exercise = setEx()
        newItem.person = Fetching().fetchUser()
        newItem.set_number = Int16(list.loadRepNum() ?? 0)
        newItem.repeats = Int16(list.loadRepsNum() ?? 8)
        newItem.weight = list.loadWeightNum() ?? 5.0
        newItem.calories = Int16(list.loadCalNum() ?? 100)
        newItem.duration = Int16(list.loadDurNum() ?? 60)
        newItem.distance = list.loadDistNum() ?? 1.0
        
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
    
    func setEx() -> Exercise{
        var exercises: [Exercise] = []
        var exercisesString: [String] = []
        let fetchRequest = NSFetchRequest<Exercise>(entityName: "Exercise")
        
        do {
            exercises = try context.fetch(fetchRequest)
            
        } catch let err as NSError {
            print(err)
        }
        for ex in exercises{
            exercisesString.append(ex.name ?? "")
        }
        if let indexPosition = exercisesString.firstIndex(of: list.loadRow() ?? ""){
            return exercises[indexPosition]
        } else {
            list.saveRow(NSLocalizedString("Exercise", comment: ""))
            return list.add()
            
        }
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
        saveRow(NSLocalizedString("Back hyperextension", comment: ""))
        
    }
    func save(_ strings: [String]){
        UserDefaults.standard.set(strings, forKey: "ex")
    }
    func saveRow(_ row: String){
        UserDefaults.standard.set(row, forKey: "row")
    }
    func loadRow() -> String?{
        UserDefaults.standard.string(forKey: "row")
    }
    func saveRepNum(_ rep: Int){
        UserDefaults.standard.set(rep, forKey: "repnum")
    }
    func loadRepNum() -> Int?{
        (UserDefaults.standard.integer(forKey: "repnum") + 1)
    }
    func saveRepsNum(_ reps: Int){
        UserDefaults.standard.set(reps, forKey: "repsnum")
    }
    func loadRepsNum() -> Int?{
        UserDefaults.standard.integer(forKey: "repsnum")
    }
    func saveCalNum(_ cal: Int){
        UserDefaults.standard.set(cal, forKey: "calnum")
    }
    func loadCalNum() -> Int?{
        UserDefaults.standard.integer(forKey: "calnum")
    }
    func saveDurNum(_ dur: Int){
        UserDefaults.standard.set(dur, forKey: "durnum")
    }
    func loadDurNum() -> Int?{
        UserDefaults.standard.integer(forKey: "durnum")
    }
    func saveDistNum(_ dist: Double){
        UserDefaults.standard.set(dist, forKey: "distnum")
    }
    func loadDistNum() -> Double?{
        UserDefaults.standard.double(forKey: "distnum")
    }
    func saveWeightNum(_ weight: Double){
        UserDefaults.standard.set(weight, forKey: "weightnum")
    }
    func loadWeightNum() -> Double?{
        UserDefaults.standard.double(forKey: "weightnum")
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
class SettingsData {
    let gendersSave = ["Female",
                       "Male",
                      "Other"]
    let gendersShow = [NSLocalizedString("Female", comment: ""),
                       NSLocalizedString("Male", comment: ""),
                       NSLocalizedString("Other", comment: "")]
    let typesSave = ["Cardio",
                 "Strength"]
    
    let typesShow = [NSLocalizedString("Cardio", comment: ""),
                 NSLocalizedString("Strength", comment: "")]
}

