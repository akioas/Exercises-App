

import UIKit


class FirstLaunch: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(true)
        if UserVariables().isFirstLaunch(){ //!
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "viewcontroller") as! ViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
    }
}

class FirstLaunchText: UIViewController, UITextFieldDelegate{
    
    
    var name = ""
    var birthday = ""
    var sex = ""
    var weight = ""
    
    @IBOutlet weak var nameField: UITextField!
//    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var sexField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    
    @IBAction func nameEdited(_ sender: Any) {
        
        name = nameField.text ?? "user"
    }/*
    @IBAction func birthdayEdited(_ sender: Any) {
        
        birthday = birthdayField.text ?? "unknown"
    }
      */
    @IBAction func birthdayEdited(_ sender: Any) {
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
//        user.save(birthday, forKey: user.birthdayKey)
        user.save(sex, forKey: user.sexKey)
        user.save(weight, forKey: user.weightKey)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        nameField.delegate = self
//        birthdayField.delegate = self
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

extension FirstLaunchText {

    @objc func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(FirstLaunchText.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
