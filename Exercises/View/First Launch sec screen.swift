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
    
    @IBOutlet weak var stackView: UIStackView!
    var name = ""
    var birthday = Date()
    var sex = ""
    var weight = ""
    var height = ""
    
    let sexes = [NSLocalizedString("Female", comment: ""),
                 NSLocalizedString("Male", comment: ""),
                 NSLocalizedString("Other", comment: "")]
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var birthdayButton: UIButton!
    @IBOutlet weak var sexButton: UIButton!
    @IBOutlet weak var weightField: UITextField!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var heightField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        self.hideOnTap()
        nameField.delegate = self
        weightField.delegate = self
        heightField.delegate = self
        setupDatePicker()
        setupPicker()
        start.setBotButtonText(button: startButton, text: NSLocalizedString("Start", comment: "start button"))
        start.setButtonText(button: birthdayButton, text: NSLocalizedString(" ", comment: ""))
        start.setButtonText(button: sexButton, text: NSLocalizedString(" ", comment: ""))

        let height = self.view.safeAreaLayoutGuide.layoutFrame.height
        let startBConstraint = NSLayoutConstraint(item: startButton!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: height * 0.85)
        NSLayoutConstraint.activate([startBConstraint])
        nameField.layer.cornerRadius = 15
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        nameField.layer.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0).cgColor
        weightField.layer.cornerRadius = 15
        weightField.layer.borderWidth = 1
        weightField.layer.borderColor = UIColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        weightField.layer.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0).cgColor
        heightField.layer.cornerRadius = 15
        heightField.layer.borderWidth = 1
        heightField.layer.borderColor = UIColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        heightField.layer.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0).cgColor
        startButton.layer.cornerRadius = 20
        startButton.layer.backgroundColor = UIColor.init(red: 0.09, green: 0.49, blue: 0.9, alpha: 1.0).cgColor
        
    }
    override func viewDidAppear(_ animated: Bool) {
        topImage(view: view, type: .firstScreen)
        setupHeader(view, width: view.frame.width)
        stackView.spacing = view.frame.height / 50

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
    @IBAction func heightEdited(_ sender: Any) {
        height = heightField.text ?? ""
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
        UserValues().save(birthday: birthday, name: name, sex: sex, weight: weight, height: height)

        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    func setupHeader(_ view: UIView, width: CGFloat){
        
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 50))
        let textLabel = UILabel()
        
        textLabel.frame = CGRect.init(x: 10, y: 0, width: width - 20, height: 50)
        textLabel.numberOfLines = 2
        textLabel.text = "Tell us about you"
        textLabel.font = .systemFont(ofSize: 24)
        textLabel.textColor = .white
        textLabel.textAlignment = .center
        header.backgroundColor = .clear
        
        header.addSubview(textLabel)
        
        
        view.addSubview(header)
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
           if (textField == weightField) || (textField == heightField) {
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
