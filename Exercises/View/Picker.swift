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
    var exersises: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        exersises = list.load()

        callBackPicker = { value, currentEx in
            print(value)
            print(currentEx)
            print("!!")
//            let currentEx = self.exercises[num]
            currentEx.setValue(value, forKey: "name")
            DataModel().saveModel()
//            self.tableView.reloadData()
//            print(self.exercises[num])
        }
        
        picker.delegate = self
        picker.dataSource = self
//        picker.translatesAutoresizingMaskIntoConstraints = true
        picker.backgroundColor = .white
        picker.contentMode = .bottom

       
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        
        let spaceButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(displayAlert))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
            
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
        
            

        picker.frame = CGRect.init(x: 0.0, y: 50, width: UIScreen.main.bounds.size.width, height: 300)
    
//        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 350, width: UIScreen.main.bounds.size.width, height: 50))
       
        view.addSubview(picker)

        view.addSubview(toolBar)
        toolBar.sizeToFit()

    
    }
    
    
    @objc func displayAlert() {

        let alertController = UIAlertController(title: "Добавить упражнение", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Упражнение"
            }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
            self.exersises.insert(firstTextField.text ?? "", at: self.exersises.endIndex)
            self.list.save(self.exersises)
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
        let vc = ViewController()
        self.dismiss(animated: false, completion: {
            NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKey), object: self)
        })
    }
   
    @objc func donePicker(){
        print(object)
        callBackPicker?(selected, object!)
        
        print(selected)
        print(pickerNum)
        cancelPicker()
    }
    
    
}

extension Picker{

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        exersises.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exersises[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        callBackPicker?(allExersizes[row], (pickerView.getNum()))
        print(pickerNum)
        selected = exersises[row]
        print(selected)
    }
}
