import UIKit
import CoreData

class FirstLaunchText: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    let dataModel = DataModel()
    let start = StartText()
    
    let datePicker = UIDatePicker()
    let picker = UIPickerView()
    let dateFormatter = DateFormatter()
    var isPickingDate = false
    var isPickingSex = false
    
    var name = ""
    var birthday = Date()
    var sex = ""
    var weight = ""
    
    let sexes = [NSLocalizedString("Female", comment: ""),
                 NSLocalizedString("Male", comment: ""),
                 NSLocalizedString("Other", comment: "")]
    
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
        start.setBotButtonText(button: startButton, text: NSLocalizedString("Start", comment: "start button"))
        start.setButtonText(button: birthdayButton, text: NSLocalizedString("Birthday", comment: ""))
        start.setButtonText(button: sexButton, text: NSLocalizedString("Sex", comment: ""))

        let height = self.view.safeAreaLayoutGuide.layoutFrame.height
        let startBConstraint = NSLayoutConstraint(item: startButton!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: height * 0.85)
        let appLabelConstraint = NSLayoutConstraint(item: appLabel!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: height * 0.15)
        NSLayoutConstraint.activate([startBConstraint, appLabelConstraint])

    }
    
    @IBAction func nameEdited(_ sender: Any) {
        name = nameField.text ?? ""
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
        weight = weightField.text ?? ""
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
        UserValues().save(birthday: birthday, name: name, sex: sex, weight: weight)

        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
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
            start.changeText(button: birthdayButton, with: dateFormatter.string(from: (datePicker.date)))
            datePicker.removeFromSuperview()
            isPickingDate = false
        } else if isPickingSex{
            if sex == ""{
                sex = sexes.first ?? ""
            }
            start.changeText(button: sexButton, with: sex)
            picker.removeFromSuperview()
            isPickingSex = false
        } else {
            view.endEditing(true)
        }
    }
}
