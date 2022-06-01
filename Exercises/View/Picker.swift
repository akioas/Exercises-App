import UIKit
import CoreData
import NotificationCenter


class Picker: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    var callBackPicker:((_ value:String, _ currentEx: NSManagedObject)->())?
    
    var picker  = UIPickerView()
    var toolBar = UIToolbar()
    var selected = ""
    var pickerNum = 0
    var object: NSManagedObject? = nil
    let list = ExercisesList()
    var exercises: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideOnTap()

        exercises = list.load()
        
        callBackPicker = { value, currentEx in
            
            if value == ""{
                currentEx.setValue(self.exercises.first, forKey: "name")
            } else {
                currentEx.setValue(value, forKey: "name")
            }
            DataModel().saveModel()
            
        }
        self.view.backgroundColor = .clear
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .systemBackground
        picker.contentMode = .center
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        
        toolBar.frame = CGRect.init(x: 0.0, y: (UIScreen.main.bounds.size.height - 300) / 2 - 50, width: UIScreen.main.bounds.size.width, height: 50)
        picker.frame = CGRect.init(x: 0.0, y: (UIScreen.main.bounds.size.height - 300) / 2, width: UIScreen.main.bounds.size.width, height: 200)
        
        //        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 350, width: UIScreen.main.bounds.size.width, height: 50))
        
        view.addSubview(picker)
        
        view.addSubview(toolBar)
//        toolBar.sizeToFit()
        
        
    }
    
    
    @objc func displayAlert() {
        
        let alertController = UIAlertController(title: "Добавить упражнение", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Упражнение"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.exercises.insert(firstTextField.text ?? "", at: self.exercises.endIndex)
            self.list.save(self.exercises)
            self.picker.reloadAllComponents()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        
        
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func setNum(_ num: Int, ex: NSManagedObject){
        pickerNum = num
        object = ex
    }
    
    @objc func cancelPicker() {
        self.dismiss(animated: false, completion: {
            NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKey), object: self)
        })
    }
    
    @objc func donePicker(){
        callBackPicker?(selected, object!)
        cancelPicker()
    }
    
    
}

extension Picker{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        exercises.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exercises[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        callBackPicker?(allExersizes[row], (pickerView.getNum()))
        print(pickerNum)
        selected = exercises[row]
        print(selected)
    }
}

extension Picker {

    @objc func hideOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(Picker.dismissView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissView() {
        donePicker()
    }
}
