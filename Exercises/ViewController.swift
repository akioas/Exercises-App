

import UIKit
import CoreData

class ViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    let cellId = "cellId"
    var exercises: [NSManagedObject] = []
    var callBackStepper:((_ value:Int, _ num: Int, _ name: String)->())?

    var picker  = UIPickerView()

    var toolBar = UIToolbar()

    
    
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

        view.backgroundColor = .gray
        
        let tableView = UITableView()
        view.addSubview(tableView)
        setupTableView()
//        tableView.register(TableViewCell.self, forCellReuseIdentifier:cellId)

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
   
     
}

extension ViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return exercises.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    @objc func showPicker(){
        picker.delegate = self
        picker.dataSource = self
    picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
    let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
    
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.view.addSubview(picker)

        self.view.addSubview(toolBar)


    }
    @objc func donePicker() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let currentEx = exercises[indexPath.section]
        cell.textLabel?.text = setText(item: (indexPath.item), currentEx: currentEx)
        if indexPath.row == 1{
                    let newButton = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
                    newButton.setImage(UIImage(systemName: "doc.fill"), for: .normal)
            newButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
            cell.accessoryView = newButton
            
        } else if indexPath.row == 2{
            setupStepper(cell, tag: indexPath.section, value: Double((getRep(currentEx: currentEx))), name: "rep", max: 10.0, step: 1.0)
            callBack()
        } else if (indexPath.row == 3){
            setupStepper(cell, tag: indexPath.section, value: Double((getReps(currentEx: currentEx))), name: "reps", max: 100.0, step: 1.0)
            callBack()
        } else if (indexPath.row == 4){
            setupStepper(cell, tag: indexPath.section, value: Double((getWeight(currentEx: currentEx))), name: "weight", max: 300.0, step: 5.0)
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


extension ViewController{

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        exercises.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allExersizes[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(allExersizes[row])
    }
}
