

import UIKit


class FirstLaunch: UIViewController{
    
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.borderWidth = 1
    }
}

class FirstLaunchText: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var startButton: UIButton!
    
    var name = ""
    var birthday = ""
    var sex = ""
    var weight = ""
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var sexField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    
    @IBAction func nameEdited(_ sender: Any) {
        
        name = nameField.text ?? "user"
    }
    @IBAction func birthdayEdited(_ sender: Any) {
        
        birthday = birthdayField.text ?? "unknown"
    }
    @IBAction func sexEdited(_ sender: Any) {
        
        sex = sexField.text ?? "unknown"

    }
    @IBAction func weightEdited(_ sender: Any) {
        
        weight = weightField.text ?? "unknown"
        
    }
    
    @IBAction func startAction(_ sender: Any) {
        let user = UserVariables()
        user.wasLaunched()
        user.save(name, forKey: "name")
        user.save(birthday, forKey: "birthday")
        user.save(sex, forKey: "sex")
        user.save(weight, forKey: "weight")
        let vc = ViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.borderWidth = 1
        nameField.delegate = self
        birthdayField.delegate = self
        sexField.delegate = self
        weightField.delegate = self
    }
    
}

extension FirstLaunchText {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
