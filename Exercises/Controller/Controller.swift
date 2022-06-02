
import UIKit
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

class StartText {
    func changeText(button: UIButton, with text: String){
        if let attributedTitle = button.attributedTitle(for: .normal) {
            let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
            mutableAttributedTitle.replaceCharacters(in: NSMakeRange(0, mutableAttributedTitle.length), with: text)
            button.setAttributedTitle(mutableAttributedTitle, for: .normal)
            button.tintColor = .label
        }
    }

    func setBotButtonText(button: UIButton, text: String){
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.label,
                           NSAttributedString.Key.font: UIFont(name: "System Font Regular", size: 40)]
        let attrString = NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any] )
        button.setAttributedTitle(attrString, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func setButtonText(button: UIButton, text: String){
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.placeholderText,
                           NSAttributedString.Key.font: UIFont(name: "System Font Regular", size: 25)]
        let attrString = NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any] )
        button.setAttributedTitle(attrString, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemFill.cgColor
        button.layer.backgroundColor = UIColor.secondarySystemFill.cgColor
    }
}

class AllowedText {
    var allowedCharacters = CharacterSet(charactersIn:"")
    var characterSet = CharacterSet(charactersIn:"")

    func textDigits(string:String) -> Bool{
        allowedCharacters = CharacterSet(charactersIn:"0123456789")
        characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
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
        if date == currDate{
            return "Not set"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale.current)
            let text = dateFormatter.string(from: date)
            return text
        }
    }
}

var botPadding = 0.0
var topPadding = 0.0
var yBot = 0.0
var yourName = ""
