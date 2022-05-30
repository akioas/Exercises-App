
import UIKit
import CoreData


class GetData{
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
    //    dateFormatter.dateFormat = "dd.MM.YY"
        dateFormatter.dateFormat = "dd.MM.YY hh:mm:ss"
        let text = dateFormatter.string(from: (currentEx.value(forKey: "date") as! Date))
        return text
    }
}

func changeText(button: UIButton, with text: String){
    if let attributedTitle = button.attributedTitle(for: .normal) {
        let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
        mutableAttributedTitle.replaceCharacters(in: NSMakeRange(0, mutableAttributedTitle.length), with: text)
        button.setAttributedTitle(mutableAttributedTitle, for: .normal)
        button.tintColor = .label
    }
}


class AllowedText{
    var allowedCharacters = CharacterSet(charactersIn:"")
    var characterSet = CharacterSet(charactersIn:"")

    func textDigits(string:String) -> Bool{
        allowedCharacters = CharacterSet(charactersIn:"0123456789")
        characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
