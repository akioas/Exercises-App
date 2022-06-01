
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
            return ("Rep: " + String(currentEx.value(forKey: "rep") as? Int16 ?? 0))
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
        dateFormatter.dateFormat = "dd.MM.YY"
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

class SaveValues {
    func save(birthday: Date, name: String, sex: String, weight: String){
        let userVar = UserVariables()
        let dataModel = DataModel()
        userVar.wasLaunched()
        let user = dataModel.addUser()
        user.setValue(birthday, forKey: userVar.birthdayKey)
        user.setValue(name, forKey: userVar.nameKey)
        user.setValue(sex, forKey: userVar.sexKey)
        user.setValue(Int(weight), forKey: userVar.weightKey)
        dataModel.saveModel()
    }
}

var botPadding = 0.0
var topPadding = 0.0
