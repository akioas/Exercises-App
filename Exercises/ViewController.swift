

import UIKit
import CoreData
import NotificationCenter


let notificationKey = "Key"

class ViewController: UITableViewController {
  
    
    let data = GetData()
    var selected = ""
    
    let cellId = "cellId"
    var exercises: [NSManagedObject] = []
    var callBackStepper:((_ value:Int, _ num: Int, _ name: String)->())?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
        
    }
    
    func fetch(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
            do {
                exercises = try context.fetch(fetchRequest)
                print(exercises)
            } catch let err as NSError {
                print(err)
            }
            tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: NSNotification.Name(rawValue: notificationKey),
                                               object: nil)

        view.backgroundColor = .gray
        
        let tableView = UITableView()
        view.addSubview(tableView)
        setupTableView()

        self.tableView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        setupButton()
        
    }
    
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func setupButton(){
        let button = UIButton(frame: CGRect(x: 40, y: 100, width: UIScreen.main.bounds.width - 80, height: 50))
        button.backgroundColor = .systemIndigo
        button.setTitle("Добавить", for: .normal)
        button.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        
        self.view.addSubview(button)
        button.frame.origin.y = -60
    }
    
    @objc func addItem(){
        DataModel().addModel()
        fetch()
    }
    
    @objc func stepperValueChanged(_ sender:Stepper!)
        {
            callBackStepper?(Int(sender.value), sender.getNum(), sender.getName())
        }
   
    @objc func refresh(){
        self.tableView.reloadData()

    }
}

extension ViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return exercises.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    @objc func showPicker(_ sender:Button!){
        showVC(sender.getNum())

    }
    
    func showVC(_ num: Int){
        let vc = Picker()
        self.present(vc, animated: false, completion: {
            vc.setNum(num, ex: self.exercises[num])
        })
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let currentEx = exercises[indexPath.section]
        cell.textLabel?.text = data.setText(item: (indexPath.item), currentEx: currentEx)
        if indexPath.row == 1{
            
                    let newButton = Button(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            newButton.setNum(num: indexPath.section)
                    newButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
            newButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
            cell.accessoryView = newButton
            
            
        } else if indexPath.row == 2{
            setupStepper(cell, tag: indexPath.section, value: Double((data.getRep(currentEx: currentEx))), name: "rep", max: 10.0, step: 1.0)
            callBack()
        } else if (indexPath.row == 3){
            setupStepper(cell, tag: indexPath.section, value: Double((data.getReps(currentEx: currentEx))), name: "reps", max: 100.0, step: 1.0)
            callBack()
        } else if (indexPath.row == 4){
            setupStepper(cell, tag: indexPath.section, value: Double((data.getWeight(currentEx: currentEx))), name: "weight", max: 300.0, step: 5.0)
            callBack()
        } else {
            cell.accessoryView = nil
        }
        return cell
    }
    
    func callBack(){
        callBackStepper = { value, num, name in
            let currentEx = self.exercises[num]
            currentEx.setValue(value, forKey: name)
            DataModel().saveModel()
            self.tableView.reloadData()
        }
    }
        
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 5
        }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return UIView()
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }

    func setupStepper(_ cell: UITableViewCell, tag: Int, value: Double, name: String, max: Double, step: Double){
        let stepper = Stepper()
        stepper.minimumValue = 0
        stepper.maximumValue = max
        stepper.value = value
        stepper.stepValue = step
        stepper.setNum(num: tag)
        stepper.setName(name: name)
        stepper.addTarget(self, action: #selector(self.stepperValueChanged(_:)), for: .valueChanged)
        cell.accessoryView = stepper
    }

}






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
       
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        
        let spaceButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(displayAlert))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
            
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
        

    print(pickerNum)
            
        picker.contentMode = .bottom

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
     
            
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
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
