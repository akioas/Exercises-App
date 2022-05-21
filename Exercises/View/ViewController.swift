

import UIKit
import CoreData
import NotificationCenter



let notificationKey = "Key"

class ViewController: UITableViewController {
    var datePicker : UIDatePicker!
    let toolBar = UIToolbar()
    
    var isFiltered = false
    let data = GetData()
    var date = Date()
    var selected = ""
    let cellId = "cellId"
    var exercises: [NSManagedObject] = []
    
    var callBackStepper:((_ value:Int, _ num: Int, _ name: String)->())?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch(isFiltered)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: NSNotification.Name(rawValue: notificationKey),
                                               object: nil)
        
        
        
        view.backgroundColor = .gray
        setupNavBar()
        setupTableView()
        
    }
    
    func deleteLast(_ object: NSManagedObject){
        DataModel().delete(object)
        refresh()
    }
    
    func fetch(_ isFiltered: Bool){
        //        change
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        if isFiltered{
            let (startDate, endDate) = dates(for: date)
            fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as CVarArg, endDate as CVarArg)
        }
        
        do {
            self.exercises = try context.fetch(fetchRequest)
            NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKey), object: self)
            
        } catch let err as NSError {
            print(err)
        }
        
    }
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupNavBar(){
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        view.addSubview(navBar)
        
        let navItem = UINavigationItem(title: "")
        let addItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItem))
        let clockItem = UIBarButtonItem(title: "Date", style: .plain, target: self, action: #selector(clockItem))
        navItem.rightBarButtonItems = [addItem, clockItem]
        
        
        navBar.setItems([navItem], animated: false)
        let tableView = UITableView()
        view.addSubview(tableView)
    }
    
    
    func setDate(_ getDate: Date){
        date = getDate
        isFiltered = true
        
        fetch(isFiltered)
        
    }
    
    func dates(for date: Date) -> (start: Date, end: Date){
        let startDate = Calendar.current.startOfDay(for: date)
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let endDate = Calendar.current.date(byAdding: components, to: startDate)!
        return (startDate, endDate)
    }
    
    @objc func addItem(){
        let vc = AddExercise()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    @objc func clockItem(){
        setupDatePicker()
    }
    
    @objc func refresh(){
        self.tableView.reloadData()
        
    }
    
    func setupDatePicker(){
        
        datePicker = UIDatePicker()
        datePicker.frame = CGRect.init(x: 0.0, y: 50, width: UIScreen.main.bounds.size.width, height: 100)
        datePicker.backgroundColor = .lightGray
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.contentMode = .bottom
        view.addSubview(datePicker)
        
        toolBar.barStyle = .default
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
        cancelDate()
        
        
    }
    
    @objc func cancelDate() {
        datePicker.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
    
    @objc func deleteObject(_ sender:Button!){
        tableView.beginUpdates()

        tableView.deleteSections(IndexSet([sender.num]), with: .fade)
        DataModel().delete(exercises[sender.num])
        fetch(isFiltered)
        tableView.endUpdates()

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
    
}

extension ViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print(exercises.count)
        return exercises.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let currentEx = exercises[indexPath.section]
        cell.textLabel?.text = data.setText(item: (indexPath.item), currentEx: currentEx)
        if indexPath.row == 0{
            let deleteButton = Button(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            deleteButton.setNum(num: indexPath.section)
            deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
            deleteButton.tintColor = .label
            deleteButton.addTarget(self, action: #selector(deleteObject), for: .touchUpInside)
            cell.accessoryView = deleteButton
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
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let vc = AddExercise()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: {
            vc.loadObject(self.exercises[indexPath.section])
        })
        
    }
    
}

