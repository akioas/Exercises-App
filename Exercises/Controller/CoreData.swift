
import CoreData


class GetData {
    func setText(item: Int, currentEx: NSManagedObject) -> String{
        switch item{
        case 0:
            return caseDate(currentEx)
        case 1:
            return currentEx.value(forKey: "name") as? String ?? ""
        case 2:
            return ("Set: " + String(currentEx.value(forKey: "rep") as? Int16 ?? 0))
        case 3:
            return ("Reps: " + String(currentEx.value(forKey: "reps") as? Int16 ?? 0))
        case 4:
            return ("Weight: " + String(currentEx.value(forKey: "weight") as? Int16 ?? 0))
        case 5:
            return String((currentEx.value(forKey: "weight") as? Int16 ?? 0) * (currentEx.value(forKey: "reps") as? Int16 ?? 0))
        
        default:
            return ""
        }
    }

    func getRep(currentEx: NSManagedObject) -> Int16{
            return (currentEx.value(forKey: "rep") as? Int16 ?? 0)
    }

    func getReps(currentEx: NSManagedObject) -> Int16{
            return (currentEx.value(forKey: "reps") as? Int16 ?? 0)
    }

    func getWeight(currentEx: NSManagedObject) -> Int16{
            return (currentEx.value(forKey: "weight") as? Int16 ?? 0)
    }

    func caseDate(_ currentEx: NSManagedObject) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale.current)
        let text = dateFormatter.string(from: (currentEx.value(forKey: "date") as! Date))
        return text
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
    }
    func save(birthday: Date, name: String, sex: String, weight: String){
        userVar.wasLaunched()
        let user = dataModel.addUser()
        user.setValue(birthday, forKey: userVar.birthdayKey)
        user.setValue(name, forKey: userVar.nameKey)
        user.setValue(sex, forKey: userVar.sexKey)
        user.setValue(Int(weight), forKey: userVar.weightKey)
        dataModel.saveModel()
    }
    func saveOne(value: Any, key: Keys, user: NSManagedObject){
        var newKey = ""
        switch key{
        case .weight:
            newKey = userVar.weightKey
        case .name:
            newKey = userVar.nameKey
        case .sex:
            newKey = userVar.sexKey
        case .birthday:
            newKey = userVar.birthdayKey
        }
        if key == .weight{
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
        }
    
    }
    func getSex(_ user: NSManagedObject) -> String{
        let sex = user.value(forKey: userVar.sexKey) as? String ?? ""
        if sex == ""{
            return "Not set"
        } else {
            return sex
        }
    }
    func getName(_ user: NSManagedObject) -> String{
        let name = user.value(forKey: userVar.nameKey) as? String ?? ""
        if name == ""{
            return "Not set"
        } else {
            return name
        }
    }
    func getWeight(_ user: NSManagedObject) -> String{
        let weight = user.value(forKey: userVar.weightKey) as? Int16 ?? 0
        if weight != 0 {
            return String(weight)
        } else {
            return "Not set"
        }
    }
    func getDate(_ user: NSManagedObject) -> String{
        let currDate = Date()
        let date = (user.value(forKey: userVar.birthdayKey) as? Date ?? currDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale.current)
        let text = dateFormatter.string(from: date)
        let currDateStr = dateFormatter.string(from: currDate)
        if currDateStr == text{
            return "Not set"
        } else {
            
            return text
        }
    }
}

