import UIKit

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



var botPadding = 0.0
var topPadding = 0.0
var yBot = 0.0
var yourName = ""
class Items {
    func setupBotButtons(_ button: UIButton, buttonNum num: Int, view: UIView, systemName: String = "", named: String = "", isCore: Bool = false){
        let frame = view.frame
        var img = UIImage()
        var heightVar = 0.0
        if !isCore{
            heightVar = topPadding
        }
        yBot = frame.height - frame.width / 10 - topPadding + heightVar
        button.frame = CGRect(x: CGFloat(num - 1) * frame.width / 4 , y: yBot , width: frame.width / 4 + 1.5, height: frame.width / 10)
        if systemName != ""{
            let configuration = UIImage.SymbolConfiguration(pointSize: frame.width / 8)
            img = UIImage(systemName: systemName, withConfiguration: configuration) ?? UIImage()
        } else {
            img = UIImage(named: named)?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        }
        button.setImage(img, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor.secondarySystemBackground
        button.tintColor = UIColor.label
            
        view.addSubview(button)
    }

    
}
func setupDatePicker(datePicker: UIDatePicker, toolBar: UIToolbar){
    datePicker.frame = CGRect.init(x: 0.0, y: 50, width: UIScreen.main.bounds.size.width, height: 100)
    datePicker.backgroundColor = .lightGray
    datePicker.datePickerMode = UIDatePicker.Mode.date
    datePicker.contentMode = .bottom
    
    toolBar.barStyle = .default
    toolBar.sizeToFit()
    toolBar.isUserInteractionEnabled = true
}
