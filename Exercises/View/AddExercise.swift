
import UIKit
import CoreData

class AddExercise: UITableViewController{
    
    var object: NSManagedObject = DataModel().addModel()
    let cellId = "cellId"
    let data = GetData()
    var callBackStepper:((_ value:Int, _ name: String)->())?
    var toolBar = UIToolbar()


    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: NSNotification.Name(rawValue: notificationKey),
                                               object: nil)
        view.backgroundColor = .gray
        setupTableView()

        setupNavBar()
        
    }
    
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupNavBar(){
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        
        
        let navItem = UINavigationItem(title: "")
        let addItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        let cancelItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navItem.rightBarButtonItems = [addItem, cancelItem]
        
        
        navBar.setItems([navItem], animated: false)
        let tableView = UITableView()
        view.addSubview(tableView)
        view.addSubview(navBar)
        print(navBar.frame)
    }
    
    @objc func cancel(){
        DataModel().delete(object)
        self.dismiss(animated: false)
    }
    
    @objc func done(){
        self.dismiss(animated: false, completion: {
            NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKey), object: self)
        })
        
    }
    
   
    @objc func showPicker(){
        let vc = Picker()
        self.present(vc, animated: false, completion: {
            vc.setNum(0, ex: self.object)
        })
        
    }
    
    @objc func stepperValueChanged(_ sender:Stepper!)
    {
        callBackStepper?(Int(sender.value), sender.getName())
    }
    func callBack(){
        callBackStepper = { value, name in
            self.object.setValue(value, forKey: name)
            DataModel().saveModel()
            self.tableView.reloadData()
        }
    }
    @objc func refresh(){
        self.tableView.reloadData()
        
    }
}



extension AddExercise {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
   

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = data.setText(item: (indexPath.item), currentEx: object)
        if indexPath.row == 1{
            
            let newButton = Button(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            newButton.setNum(num: indexPath.section)
            newButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
            newButton.tintColor = .black
            newButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
            cell.accessoryView = newButton
            
            
        } else if indexPath.row == 2{
            setupStepper(cell, tag: indexPath.section, value: Double((data.getRep(currentEx: object))), name: "rep", max: 10.0, step: 1.0)
            callBack()
        } else if (indexPath.row == 3){
            setupStepper(cell, tag: indexPath.section, value: Double((data.getReps(currentEx: object))), name: "reps", max: 100.0, step: 1.0)
            callBack()
        } else if (indexPath.row == 4){
            setupStepper(cell, tag: indexPath.section, value: Double((data.getWeight(currentEx: object))), name: "weight", max: 300.0, step: 5.0)
            callBack()
        } else {
            cell.accessoryView = nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                            section: Int) -> String? {
        if section == 0{
            return " "
        } else {
            return ("")
        }
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

