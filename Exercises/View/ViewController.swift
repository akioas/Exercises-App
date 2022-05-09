

import UIKit
import CoreData
import NotificationCenter



let notificationKey = "Key"

class ViewController: UITableViewController {
    var datePicker : UIDatePicker!
    let toolBar = UIToolbar()

    var isFiltered = false
    let data = GetData()
    var selected = ""
    
    let cellId = "cellId"
    var exercises: [NSManagedObject] = []
    
    var callBackStepper:((_ value:Int, _ num: Int, _ name: String)->())?
    var date = Date()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch(isFiltered)
        print(exercises.count)
        
    }
    
    func setDate(_ getDate: Date){
        date = getDate
     
        print(date)
        isFiltered = true
        let startDate = Calendar.current.startOfDay(for: date)
                var components = DateComponents()
                components.day = 1
                components.second = -1
                let endDate = Calendar.current.date(byAdding: components, to: startDate)!
            fetch(isFiltered, startDate: startDate, endDate: endDate)
                /*
        let oldEx = exercises
        var toDelete: [Int] = []
        for (index, value) in exercises.enumerated(){
            if data.caseDate(oldEx[index]) != data.caseDate(exercises[index]){
                toDelete.append(index)
            }
        }
        print(toDelete)
            tableView.deleteSections(IndexSet(toDelete), with: .none)
         */
       
        
    }
    
    
    
    func fetch(_ isFiltered: Bool, startDate: Date = Date(), endDate: Date = Date()){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        if isFiltered{
            fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as CVarArg, endDate as CVarArg)
        }

        do {
            self.exercises = try context.fetch(fetchRequest)
            tableView.reloadData()
            
            print(exercises)

        } catch let err as NSError {
            print(err)
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: NSNotification.Name(rawValue: notificationKey),
                                               object: nil)
        
        
        view.backgroundColor = .gray
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        view.addSubview(navBar)
        
        let navItem = UINavigationItem(title: "")
        let addItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItem))
        let clockItem = UIBarButtonItem(title: "Date", style: .plain, target: self, action: #selector(clockItem))
        navItem.rightBarButtonItems = [addItem, clockItem]
        
        
        navBar.setItems([navItem], animated: false)
        let tableView = UITableView()
        view.addSubview(tableView)
        setupTableView()
        tableView.dataSource = self
        tableView.delegate = self

        
        //        self.tableView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        
    }
    
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    
    
    @objc func addItem(){
        DataModel().addModel()
        fetch(isFiltered)
    }
    @objc func clockItem(){
        setupDatePicker()

//        let vc = Clock()
//        self.present(vc, animated: false)
//        setDate(Date())
    }
    
    @objc func stepperValueChanged(_ sender:Stepper!)
    {
        callBackStepper?(Int(sender.value), sender.getNum(), sender.getName())
    }
    
    @objc func refresh(){
        self.tableView.reloadData()
        
    }
    
    func setupDatePicker(){
        let dateFormatter = DateFormatter()
            let locale = NSLocale.current
//
        datePicker = UIDatePicker()
        datePicker.frame = CGRect.init(x: 0.0, y: 50, width: UIScreen.main.bounds.size.width, height: 100)
        datePicker.backgroundColor = .lightGray
        datePicker.datePickerMode = UIDatePicker.Mode.date
//            datePicker.center = view.center
        datePicker.contentMode = .bottom
        view.addSubview(datePicker)


        toolBar.barStyle = .default
//            toolBar.isTranslucent = true
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDate))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDate))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

       view.addSubview(toolBar)
        toolBar.sizeToFit()
    }


@objc func doneDate() {
        let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .full
    setDate(datePicker.date)
//    let vc = ViewController()
//    self.dismiss(animated: false, completion: {
//        vc.setDate(pickedDate)
        
//    })
    cancelDate()


    }

@objc func cancelDate() {
//    self.dismiss(animated: false)
    datePicker.removeFromSuperview()
    toolBar.removeFromSuperview()
    }
    
    
    
    
}

extension ViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print(exercises.count)
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

