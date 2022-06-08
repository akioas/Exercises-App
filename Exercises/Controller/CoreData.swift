
import CoreData


class GetData {
    let vals = UserValues()
    func setText(item: Int, currentEx: ExerciseSet) -> String{
        switch item{
        case 0:
            return caseDate(currentEx, key: "date")
        case 1:
            return exerciseName(object: currentEx)
        case 2:
            return (NSLocalizedString("Set", comment: ""))
        case 3:
            return (NSLocalizedString("Reps", comment: ""))
        case 4:
            return (NSLocalizedString("Weight", comment: "") )
        case 5:
            return caseDate(currentEx, key: "created_at")
        
        default:
            return ""
        }
    }

    func getRep(currentEx: NSManagedObject) -> Int16{
            return (currentEx.value(forKey: "set_number") as? Int16 ?? 0)
    }

    func getReps(currentEx: NSManagedObject) -> Int16{
            return (currentEx.value(forKey: "repeats") as? Int16 ?? 0)
    }

    func getWeight(currentEx: NSManagedObject) -> Double{
        return (currentEx.value(forKey: "weight") as? Double ?? 0.0)
    }

    func caseDate(_ currentEx: NSManagedObject, key: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale.current)
        let text = dateFormatter.string(from: (currentEx.value(forKey: key) as? Date ?? Date()))
        return text
    }
    
    func getPerson(_ currentEx: NSManagedObject) -> NSManagedObject?{
        return (currentEx.value(forKey: "person") as? NSManagedObject)
    }
    
    func userName(object: NSManagedObject?) -> String{
        if let object = object {
            return vals.get(user: object, key: .name)
        } else {
            return NSLocalizedString("Not set", comment: "")
        }
        
    }
    func getExercise(_ currentEx: ExerciseSet) -> Exercise?{
        return (currentEx.exercise)
    }
    func exerciseName(object: ExerciseSet?) -> String{
        if let object = object{
            return getExercise(object)?.name ?? ""
        } else {
            return ""
        }
    }
}

class UserValues {
    let userVar = UserVariables()
    let dataModel = DataModel()
    enum Keys{
        case name
        case birthday
        case sex
        case weight
        case height
    }
    func save(birthday: Date, name: String, sex: String, weight: String, height: String){
        userVar.wasLaunched()
        let user = dataModel.addUser()
        user.setValue(birthday, forKey: userVar.birthdayKey)
        user.setValue(name, forKey: userVar.nameKey)
        user.setValue(sex, forKey: userVar.sexKey)
        user.setValue(Int(weight), forKey: userVar.weightKey)
        user.setValue(Int(height), forKey: userVar.heightKey)
        dataModel.saveModel()
    }
    func saveOne(value: Any, key: Keys, user: NSManagedObject){
        var newKey = ""
        switch key{
        case .weight:
            newKey = userVar.weightKey
        case .height:
            newKey = userVar.heightKey
        case .name:
            newKey = userVar.nameKey
        case .sex:
            newKey = userVar.sexKey
        case .birthday:
            newKey = userVar.birthdayKey
        }
        if key == .weight{
            user.setValue(Int(value as? String ?? ""), forKey: newKey)
        } else if key == .height{
            user.setValue(Int(value as? String ?? ""), forKey: newKey)
        } else {
            user.setValue(value, forKey: newKey)
        }
    }
    func get(user: NSManagedObject, key: Keys) -> String{
        switch key{
        case .sex:
            return getSex(user)
        case .name:
            return getName(user)
        case .weight:
            return getWeight(user)
        case .birthday:
            return getDate(user)
        case .height:
            return getHeight(user)
        }
    
    }
    func getSex(_ user: NSManagedObject) -> String{
        let sex = user.value(forKey: userVar.sexKey) as? String ?? ""
        if sex == ""{
            return NSLocalizedString("Not set", comment: "")
        } else {
            return sex
        }
    }
    func getName(_ user: NSManagedObject) -> String{
        let name = user.value(forKey: userVar.nameKey) as? String ?? ""
        if name == ""{
            return NSLocalizedString("Not set", comment: "")
        } else {
            return name
        }
    }
    func getWeight(_ user: NSManagedObject) -> String{
        let weight = user.value(forKey: userVar.weightKey) as? Int16 ?? 0
        if weight != 0 {
            return String(weight)
        } else {
            return NSLocalizedString("Not set", comment: "")
        }
    }
    func getHeight(_ user: NSManagedObject) -> String{
        let height = user.value(forKey: userVar.heightKey) as? Int16 ?? 0
        if height != 0 {
            return String(height)
        } else {
            return NSLocalizedString("Not set", comment: "")
        }
    }
    func getDate(_ user: NSManagedObject) -> String{
        let currDate = Date(timeIntervalSinceReferenceDate: 11123456789.0)
        let date = (user.value(forKey: userVar.birthdayKey) as? Date ?? Date(timeIntervalSinceReferenceDate: 11123456789.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale.current)
        let text = dateFormatter.string(from: date)
        let currDateStr = dateFormatter.string(from: currDate)
        if currDateStr == text{
            return NSLocalizedString("Not set", comment: "")
        } else {
            
            return text
        }
    }
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
