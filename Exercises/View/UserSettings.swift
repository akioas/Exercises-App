
import UIKit
import CoreData

class UserSettings: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    let tableView = UITableView()
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

    let txtField = UITextField()
    let weightField = UITextField()
    let sexes = [NSLocalizedString("Female", comment: ""),
                 NSLocalizedString("Male", comment: ""),
                 NSLocalizedString("Other", comment: "")]
    var isPickingDate = false
    var isPickingSex = false
    let start = StartText()
    let datePicker = UIDatePicker()
    let picker = UIPickerView()
    let dateFormatter = DateFormatter()
    let sexButton = UIButton()
    let birthdayButton = UIButton()
    let text = UILabel()

    override func viewWillAppear(_ animated: Bool) {
        fetch()
        getUser()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.hideOnTap()
        setupDatePicker()
        setupPicker()

    }
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .secondarySystemBackground
        setupTableView()
        topImage(view: view, type: .common)
        setupHeader(view, text: "Personal Info", button: editButton, imgName: "square.and.pencil")
       
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        self.navigationController?.isNavigationBarHidden = true

        txtFieldsBtns()
    }
    
    
    func fetch(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
    
        do {
            self.objects = try context.fetch(fetchRequest)
            
            
        } catch let err as NSError {
            print(err)
        }
        
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
    
     @objc func birthdayEdited(_ sender: Any) {
         self.view.addSubview(datePicker)
         isPickingDate = true
     }
     @objc func sexEdited(_ sender: Any) {
         self.view.addSubview(picker)
         isPickingSex = true
     }
    @objc func addItem(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "addex") as! AddExercise
        self.present(vc, animated: true)
    }
    func txtFieldsBtns(){
        txtField.frame = CGRect.init(x: 0, y: 0, width: 100, height: 20)
        weightField.frame = CGRect.init(x: 0, y: 0, width: 100, height: 20)
        txtField.keyboardType = .namePhonePad
        txtField.delegate = self
        weightField.keyboardType = .numberPad
        weightField.delegate = self
        txtField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        weightField.addTarget(self, action: #selector(weightChanged), for: .editingChanged)
        birthdayButton.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        birthdayButton.addTarget(self, action: #selector(birthdayEdited), for: .touchUpInside)
        sexButton.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        sexButton.addTarget(self, action: #selector(sexEdited), for: .touchUpInside)
        sexButton.setTitle("Пол", for: .normal)
        birthdayButton.setTitle("ДР", for: .normal)
        sexButton.setTitleColor(.label, for: .normal)
        birthdayButton.setTitleColor(.label, for: .normal)
        sexButton.contentMode = .right
        birthdayButton.contentMode = .right
        txtField.layer.borderWidth = 1
        weightField.layer.borderWidth = 1
        sexButton.layer.borderWidth = 1
        birthdayButton.layer.borderWidth = 1

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
      
    @objc func nameChanged(){
        name = txtField.text ?? ""
    }
    @objc func weightChanged(){
        weight = weightField.text ?? ""
    }
    func getUser(){
        if let object = objects.last{
            name = vals.get(user: object, key: .name)
            birthday = vals.get(user: object, key: .birthday)
            weight = vals.get(user: object, key: .weight)
            sex = vals.get(user: object, key: .sex)
        }
        refresh()
    }
    @objc func cancel(){
        self.dismiss(animated: false, completion: {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "header"), object: self)
            
        })

    }
    @objc func addNewEx(){
        
        let vc = AddExercise()
        vc.modalPresentationStyle = .fullScreen

        self.present(vc, animated: false)
    }
    @objc func toExTable(){
        
        weak var pvc = self.presentingViewController

        self.dismiss(animated: false, completion: {
            let vc = ExercisesTable()
            vc.modalPresentationStyle = .fullScreen
            pvc?.present(vc, animated: false, completion: nil)
        })
        
        

    }
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        let frame = self.view.bounds

        tableView.frame = CGRect(x: 0, y: 44 , width: frame.width, height: frame.height - 50)
        tableView.backgroundColor = .secondarySystemBackground
        view.addSubview(tableView)
       
    }
    
    
    @objc func edit(){
        isEdit = !isEdit
        if isEdit {
            
            editButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            vals.save(birthday: birthdayDate, name: name, sex: sex, weight: (weight), height: height)
            editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        }
        self.tableView.reloadData()
    }
   
    @objc func refresh(){
        self.tableView.reloadData()
        
    }
    
   
}



extension UserSettings {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
   

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let text = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        if indexPath.row == 0{
            cell.textLabel?.text = "Name:"
        } else if indexPath.row == 1{
            cell.textLabel?.text = "Birthday:"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "Weight:"
        } else {
            cell.textLabel?.text = "Sex:"
        }
        if !isEdit{
            
                if indexPath.row == 0{
                    text.text = name
                } else if indexPath.row == 1{
                    text.text = birthday
                } else if indexPath.row == 2 {
                    text.text = (weight)
                } else {
                    text.text = sex
                }
            
            cell.accessoryView = text

        } else {
            if let object = objects.last{
                
                if indexPath.row == 0{
                    
                    txtField.text = name
                    txtField.placeholder = "Имя"
                    cell.accessoryView = txtField
                } else if indexPath.row == 2{
                    if weight == "Not set"{
                        weightField.text = "0"
                    } else {
                        weightField.text = weight

                    }
                    weightField.placeholder = "Вес"
                    cell.accessoryView = weightField
                } else if indexPath.row == 3 {
                    cell.accessoryView = sexButton
                } else {
                    

                    cell.accessoryView = birthdayButton

                }
            
            }
        }

        cell.selectionStyle = .none
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    
    
}

extension UserSettings {
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
        if (textField == txtField){
            name = txtField.text ?? ""
            if let user = objects.last{
                yourName = name
                text.text = yourName
                vals.saveOne(value: name, key: .name, user: user)
            }
        } else {
            weight = weightField.text ?? ""
            if let user = objects.last{
                vals.saveOne(value: weight, key: .weight, user: user)
            }
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
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale.current)
            birthday = dateFormatter.string(from: birthdayDate)
            birthdayButton.setTitle(birthday, for: .normal)
            if let user = objects.last{
                vals.saveOne(value: birthdayDate, key: .birthday, user: user)
            }
            datePicker.removeFromSuperview()
            isPickingDate = false
        } else if isPickingSex{
            if sex == "Not set"{
                sex = sexes.first ?? ""
            }
            sexButton.setTitle(sex, for: .normal)
            if let user = objects.last{
                vals.saveOne(value: sex, key: .sex, user: user)
            }
            picker.removeFromSuperview()
            isPickingSex = false
        } else {
            if let user = objects.last{
                vals.saveOne(value: name, key: .name, user: user)
                yourName = name
                text.text = yourName
                vals.saveOne(value: weight, key: .weight, user: user)
            }
            view.endEditing(true)
        }
    }
}
