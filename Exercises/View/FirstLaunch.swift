

import UIKit


class FirstLaunch: UIViewController{
    
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.borderWidth = 1
        
    }
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(true)
        if !UserVariables().isFirstLaunch(){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "viewcontroller") as! ViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
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
        user.save(name, forKey: user.nameKey)
        user.save(birthday, forKey: user.birthdayKey)
        user.save(sex, forKey: user.sexKey)
        user.save(weight, forKey: user.weightKey)
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
