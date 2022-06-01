
import UIKit
import CoreData

class AddExercise: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let tableView = UITableView()
    var object: NSManagedObject = DataModel().addModel()
    var isNewObject = true
    let cellId = "cellId"
    let data = GetData()
    var callBackStepper:((_ value:Int, _ name: String)->())?
//    var toolBar = UIToolbar()


    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: NSNotification.Name(rawValue: notificationKey),
                                               object: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .systemBackground
        setupTableView()
        setupHeader()
//        setupNavBar()
    }
    
    func loadObject(_ object: NSManagedObject){
        context.delete(self.object)
        self.object = object
        self.isNewObject = false
        tableView.reloadData()
    }
    
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRect(x: 0, y: 50 + topPadding, width: view.frame.width, height: view.frame.height - topPadding * 2 - botPadding )
        view.addSubview(tableView)
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        let buttonCancel = UIButton(frame: CGRect(x: 20, y: 0, width: 100, height: 50))
        buttonCancel.setTitle("Cancel", for: .normal)
        buttonCancel.backgroundColor = .systemPink
        buttonCancel.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        customView.addSubview(buttonCancel)
        let buttonDone = UIButton(frame: CGRect(x: view.frame.width - 120, y: 0, width: 100, height: 50))
        buttonDone.setTitle("Done", for: .normal)
        buttonDone.backgroundColor = .systemBlue
        buttonDone.addTarget(self, action: #selector(done), for: .touchUpInside)
        customView.addSubview(buttonDone)
        tableView.tableFooterView = customView
    }
    func setupHeader(){
        let header = UIView.init(frame: CGRect.init(x: 0, y: topPadding, width: tableView.frame.width, height: 50))
        let text = UILabel()
        text.frame = CGRect.init(x: 10, y: 0, width: tableView.frame.width, height: 50)
        text.numberOfLines = 2
        text.text = "Hello, Name \nAdd an activity"
        text.textAlignment = .center
        header.backgroundColor = .systemBackground
        header.layer.borderWidth = 1
        header.layer.borderColor = UIColor.label.cgColor
        view.addSubview(header)
        header.addSubview(text)
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
        if isNewObject{
            context.delete(object)
        }
        self.dismiss(animated: false)
    }
    
    
    @objc func done(){
        DataModel().saveModel()
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
            self.tableView.reloadData()
        }
    }
    @objc func refresh(){
        self.tableView.reloadData()
        
    }
}



extension AddExercise {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
   

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = data.setText(item: (indexPath.item + 1), currentEx: object)
        if indexPath.row == 0{
            
            let newButton = Button(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            newButton.setNum(num: indexPath.section)
            newButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
            newButton.tintColor = .label
            newButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
            cell.accessoryView = newButton
            
            
        } else if indexPath.row == 1{
            setupStepper(cell, tag: indexPath.section, value: Double((data.getRep(currentEx: object))), name: "rep", max: 10.0, step: 1.0)
            callBack()
        } else if (indexPath.row == 2){
            setupStepper(cell, tag: indexPath.section, value: Double((data.getReps(currentEx: object))), name: "reps", max: 100.0, step: 1.0)
            callBack()
        } else if (indexPath.row == 3){
            setupStepper(cell, tag: indexPath.section, value: Double((data.getWeight(currentEx: object))), name: "weight", max: 300.0, step: 5.0)
            callBack()
        } else {
            cell.accessoryView = nil
        }
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

