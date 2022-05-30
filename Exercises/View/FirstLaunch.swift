

import UIKit


class FirstLaunch: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var logo: UIImageView!
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(true)
        if UserVariables().isFirstLaunch(){ //!
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "viewcontroller") as! ViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
        
        let nextBConstraint = NSLayoutConstraint(item: nextButton!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: self.view.bounds.height * 0.95)
        let logoConstraint = NSLayoutConstraint(item: logo!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: self.view.bounds.height * 0.05)
        NSLayoutConstraint.activate([logoConstraint, nextBConstraint])
         
    }
         
}






class FirstLaunchText: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let datePicker = UIDatePicker()
    let picker = UIPickerView()
    let dateFormatter = DateFormatter()
    var isPickingDate = false
    var isPickingSex = false
    
    var name = "user"
    var birthday = Date()
    var sex = "Not set"
    var weight = 0
    
    let sexes = ["Female", "Male", "Other"]
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var birthdayButton: UIButton!
    @IBOutlet weak var sexButton: UIButton!
    @IBOutlet weak var weightField: UITextField!
    
    @IBOutlet weak var appLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideOnTap()
        nameField.delegate = self
        weightField.delegate = self
        setupDatePicker()
        setupPicker()
        let startBConstraint = NSLayoutConstraint(item: startButton!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: self.view.bounds.height * 0.95)
        let appLabelConstraint = NSLayoutConstraint(item: appLabel!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: self.view.bounds.height * 0.05)
        NSLayoutConstraint.activate([startBConstraint, appLabelConstraint])

    }
    
    @IBAction func nameEdited(_ sender: Any) {
        name = nameField.text ?? "user"
    }
    @IBAction func birthdayEdited(_ sender: Any) {
        self.view.addSubview(datePicker)
        isPickingDate = true
    }
    @IBAction func sexEdited(_ sender: Any) {
        self.view.addSubview(picker)
        isPickingSex = true
    }
    @IBAction func weightEdited(_ sender: Any) {
        weight = Int(weightField.text ?? "0") ?? 0
    }
    
    func setupDatePicker(){
        datePicker.datePickerMode = .date
       
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        datePicker.center = view.center
        datePicker.backgroundColor = .systemBackground
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale.current)

    }
    func setupPicker(){
        picker.delegate = self
        picker.dataSource = self
        picker.center = view.center
        picker.backgroundColor = .systemBackground
    }
    
    @IBAction func startAction(_ sender: Any) {
        let user = UserVariables()
        user.wasLaunched()
        user.save(name, forKey: user.nameKey)
        user.save(birthday, forKey: user.birthdayKey)
        user.save(sex, forKey: user.sexKey)
        user.save(String(weight), forKey: user.weightKey)
    }
    
}

extension FirstLaunchText {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        sexes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sexes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sex = sexes[row]
    }
}

extension FirstLaunchText {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           if textField == weightField {
               return AllowedText().textDigits(string: string)
            }
            return true
        }
}

extension FirstLaunchText {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension FirstLaunchText {

    @objc func hideOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(FirstLaunchText.dismissView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissView() {
        if isPickingDate{
            birthday = datePicker.date
            changeText(button: birthdayButton, with: dateFormatter.string(from: (datePicker.date)))
            datePicker.removeFromSuperview()
            isPickingDate = false
        } else if isPickingSex{
            changeText(button: sexButton, with: sex)
            picker.removeFromSuperview()
            isPickingSex = false
        } else {
            view.endEditing(true)
        }
    }
}
