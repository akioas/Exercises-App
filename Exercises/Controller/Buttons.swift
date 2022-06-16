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
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                           NSAttributedString.Key.font: UIFont(name: "System Font Regular", size: 16)]
        let attrString = NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any] )
        button.setAttributedTitle(attrString, for: .normal)
//        button.layer.cornerRadius = 15
//        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func setButtonText(button: UIButton, text: String){
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                           NSAttributedString.Key.font: UIFont(name: "System Font Regular", size: 25),
                           ]
        let attrString = NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any] )
        button.setAttributedTitle(attrString, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        button.layer.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0).cgColor
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.gray()
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            configuration.baseForegroundColor = UIColor.label

            configuration.baseBackgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
            print(configuration)
            button.configuration = configuration
        } else {
            button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        }
        
    }
    
    func smallButton(button: UIButton){
        let constraint = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
        NSLayoutConstraint.activate([constraint])
    }
    func smallText(field: UITextField){
        let constraint = NSLayoutConstraint(item: field, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
        NSLayoutConstraint.activate([constraint])
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
    func textDigitsDot(string:String) -> Bool{
        allowedCharacters = CharacterSet(charactersIn:".,0123456789")
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
    datePicker.frame = CGRect.init(x: 0.0, y: 100, width: UIScreen.main.bounds.size.width, height: 100)
    datePicker.backgroundColor = .white
    datePicker.datePickerMode = UIDatePicker.Mode.date
    datePicker.contentMode = .bottom
    
    toolBar.barStyle = .default
    toolBar.frame = CGRect.init(x: 0.0, y: 50, width: UIScreen.main.bounds.size.width, height: 50)
    toolBar.isUserInteractionEnabled = true
}

enum YCoord{
    case firstScreen
    case common
}
func topImage(view: UIView, type: YCoord){
    
    let imgView = UIImageView()
    var newY = 44.0
    if view.frame.height < 660{
        newY = 30.0
    }
    switch type {
    case .firstScreen:
        imgView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150)
    case .common:
        imgView.frame = CGRect.init(x: 0, y: newY, width: UIScreen.main.bounds.width, height: 150)

    }
    imgView.image = UIImage(named: "Decor")
    imgView.contentMode = .scaleAspectFill
    view.addSubview(imgView)
}


func textFieldAppearance(_ field: UITextField){
    field.layer.cornerRadius = 15
    field.layer.borderWidth = 1
    field.layer.borderColor = UIColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
    field.layer.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0).cgColor
    field.textAlignment = .natural
    field.leftSpace(5)
}

enum viewType{
    case launch
    case other
}

func setupHeader(_ view: UIView, text: String, button: UIButton?, imgName named: String?, type: viewType = .other) -> UIView{
    let header = UIView()
    var newY = 44.0
    if view.frame.height < 660{
        newY = 30.0
    }
    if type == .launch{
        header.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 50)
    } else {
        header.frame = CGRect.init(x: 0, y: newY, width: view.frame.width, height: 50)
    }
    let textLabel = UILabel()
    if let button = button {
        textLabel.frame = CGRect.init(x: 10, y: 0, width: view.frame.width - 70, height: 50)
        button.frame = CGRect(x: view.frame.width - 60, y: 0, width: 50, height: 50)
        let configuratoin = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: named ?? "", withConfiguration: configuratoin), for: .normal)
        button.tintColor = .white
        button.isUserInteractionEnabled = true
        header.addSubview(button)
    } else {
        textLabel.frame = CGRect.init(x: 10, y: 0, width: view.frame.width - 20, height: 50)
    }
    textLabel.numberOfLines = 2
    textLabel.text = text
    textLabel.font = .systemFont(ofSize: 28)
    textLabel.textColor = .white
    textLabel.textAlignment = .center
    header.backgroundColor = .clear
    
    header.addSubview(textLabel)
    
    view.addSubview(header)
    return header
}
