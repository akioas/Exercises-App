
import UIKit
import CoreData

class UserSettings: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    var objects: [NSManagedObject] = []
    let cellId = "cellId"
    let data = GetData()
    let vals = UserValues()
    let items = Items()
    var isEdit = false
    let editButton = UIButton()
    var name = ""
    var birthday = ""
    var birthdayDate = Date()
    var sex = ""
    var weight = ""
    var height = ""

    var gendersSave = [String]()
    var gendersShow = [String]()
    
    var isPickingDate = false
    var isPickingSex = false
    let start = StartText()
    let datePicker = UIDatePicker()
    let picker = UIPickerView()
    let dateFormatter = DateFormatter()

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var nameField: UITextField!
    
    
    @IBOutlet weak var sexButton: UIButton!
    @IBOutlet weak var birthdayButton: UIButton!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBAction func editButtonPressed(_ sender: Any) {
        edit()
    }
    @IBOutlet weak var editSaveButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
        getUser()
        setToFalse()
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideOnTap()
        start.setupDatePicker(datePicker: datePicker, view: view, format: dateFormatter)
        setupPicker()
        stackView.spacing = view.frame.height / 70
        
        nameField.delegate = self
        heightField.delegate = self
        weightField.delegate = self
        gendersSave = start.gendersSave()
        gendersShow = start.gendersShow()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale.current)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .secondarySystemBackground
        self.navigationController?.isNavigationBarHidden = true
        

        items.topImage(view: view, type: .common)
        _ = items.setupHeader(view, text: NSLocalizedString("Personal Info", comment: ""), button: editButton, imgName: "square.and.pencil", type: .other)

        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        items.textFieldAppearance(nameField)
        items.textFieldAppearance(weightField)
        items.textFieldAppearance(heightField)
        start.setBotButtonText(button: editSaveButton, text: NSLocalizedString("Edit", comment: ""))
        editSaveButton.layer.cornerRadius = 20
        editSaveButton.layer.backgroundColor = UIColor.init(red: 0.09, green: 0.49, blue: 0.9, alpha: 1.0).cgColor
        if birthday != "" {
            start.setButtonText(button: birthdayButton, text: birthday)
        } else {
            start.setButtonText(button: birthdayButton, text: NSLocalizedString("Not set", comment: ""))
        }
        if sex != "" {
            start.setButtonText(button: sexButton, text: NSLocalizedString(sex, comment: ""))
        } else {
            start.setButtonText(button: sexButton, text: NSLocalizedString("Not set", comment: ""))
        }
        if view.frame.height < 700 {
            stackView.distribution = .fillProportionally
            start.smallButton(button: sexButton)
            start.smallButton(button: birthdayButton)
            start.smallText(field: nameField)
            start.smallText(field: weightField)
            start.smallText(field: heightField)
            start.smallButton(button: editSaveButton)
        }
        nameField.text = name
        weightField.text = weight
        heightField.text = height
        sexButton.tintColor = .black
        birthdayButton.tintColor = .black
    }
    
    
    func fetch(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
    
        do {
            self.objects = try context.fetch(fetchRequest)
              
        } catch let err as NSError {
            print(err)
        }
        
    }
    func setToFalse(){
        sexButton.isUserInteractionEnabled = false
        birthdayButton.isUserInteractionEnabled = false
        nameField.isUserInteractionEnabled = false
        heightField.isUserInteractionEnabled = false
        weightField.isUserInteractionEnabled = false
    }
    
    func setupPicker(){
        picker.delegate = self
        picker.dataSource = self
        picker.center = view.center
        picker.backgroundColor = .systemBackground
    }
    
    @IBAction func birthdayEdited(_ sender: Any) {
         self.view.addSubview(datePicker)
         isPickingDate = true
     }
    @IBAction func sexEdited(_ sender: Any) {
         self.view.addSubview(picker)
         isPickingSex = true
     }
    @IBAction func nameEdited(_ sender: Any) {
        name = nameField.text ?? ""
    }
    @IBAction func weightEdited(_ sender: Any){
        weight = weightField.text ?? ""
    }
    @IBAction func heightEdited(_ sender: Any){
        height = heightField.text ?? ""
    }
    @objc func addItem(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "addex") as! AddExercise
        self.present(vc, animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
   
    func getUser(){
        if let object = objects.last{
            name = vals.get(user: object, key: .name)
            birthday = vals.get(user: object, key: .birthday)
            weight = vals.get(user: object, key: .weight)
            height = vals.get(user: object, key: .height)
            sex = vals.get(user: object, key: .sex)
        }
    }
   
    @objc func edit(){
        isEdit = !isEdit
        if isEdit {
            editButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            start.setBotButtonText(button: editSaveButton, text: NSLocalizedString("Save", comment: ""))
            if view.frame.height < 700{
                start.smallButton(button: editSaveButton)
            }
            sexButton.isUserInteractionEnabled = true
            birthdayButton.isUserInteractionEnabled = true
            nameField.isUserInteractionEnabled = true
            heightField.isUserInteractionEnabled = true
            weightField.isUserInteractionEnabled = true
            if nameField.text == NSLocalizedString("Not set", comment: ""){
                nameField.text = ""
            }
            if heightField.text == NSLocalizedString("Not set", comment: ""){
                heightField.text = ""
            }
            if weightField.text == NSLocalizedString("Not set", comment: ""){
                weightField.text = ""
            }

        } else {
            editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
            start.setBotButtonText(button: editSaveButton, text: NSLocalizedString("Edit", comment: ""))
            if view.frame.height < 700{
                start.smallButton(button: editSaveButton)
            }
            vals.save(birthday: birthdayDate, name: name, sex: sex, weight: (weight), height: height)
            AppData().saveObjects()
            setToFalse()
            if nameField.text == ""{
                nameField.text = NSLocalizedString("Not set", comment: "")
            }
            if heightField.text == ""{
                heightField.text = NSLocalizedString("Not set", comment: "")
            }
            if weightField.text == ""{
                weightField.text = NSLocalizedString("Not set", comment: "")
            }
        }
    }
}



extension UserSettings {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        gendersShow.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gendersShow[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sex = gendersSave[row]
    }
}

extension UserSettings {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           if textField == weightField {
               return AllowedText().textDigits(string: string)
            }
            return true
        }
}

extension UserSettings {
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == nameField){
            name = nameField.text ?? ""
        } else if (textField == weightField){
            weight = weightField.text ?? ""
        } else if (textField == heightField){
            height = heightField.text ?? ""
        }
        textField.resignFirstResponder()
        return true
    }
}

extension UserSettings {

    @objc func hideOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UserSettings.dismissView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissView() {
        if isPickingDate{
            birthdayDate = datePicker.date
            birthday = dateFormatter.string(from: birthdayDate)
            start.changeText(button: birthdayButton, with: birthday)
            datePicker.removeFromSuperview()
            isPickingDate = false
        } else if isPickingSex{
            if sex == NSLocalizedString("Not set", comment: ""){
                sex = gendersSave.first ?? ""
            }
            start.changeText(button: sexButton, with: NSLocalizedString(sex, comment: ""))
            picker.removeFromSuperview()
            isPickingSex = false
        } else {
            view.endEditing(true)
        }
    }
}
