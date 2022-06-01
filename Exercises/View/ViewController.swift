

import UIKit
import CoreData
import NotificationCenter



let notificationKey = "Key"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
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
    override func viewDidAppear(_ animated: Bool) {
        topPadding = view.safeAreaInsets.top
        botPadding = view.safeAreaInsets.bottom
        setupTableView()

        setupBotButtons(buttonNum: 1, view: view, systemName: "house.fill")
        setupBotButtons(buttonNum: 2, view: view, named: "Dumbbell")
        setupBotButtons(buttonNum: 3, view: view, systemName: "plus.circle")
        setupBotButtons(buttonNum: 4, view: view, systemName: "gearshape.circle")
        let newView = UIView()
        newView.frame = CGRect(x: 5.0, y: tableView.frame.height + topPadding, width: view.frame.width - 10.0, height: 2)
        newView.backgroundColor = .quaternaryLabel
        view.addSubview(newView)
        setupHeader()
        
        //        setupNavBar()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: NSNotification.Name(rawValue: notificationKey),
                                               object: nil)
        view.backgroundColor = .systemBackground
    }
    
    @objc func buttonAction(_ sender: UIButton!) {
        print("Button tapped")
    }
    
    func deleteLast(_ object: NSManagedObject){
        DataModel().delete(object)
        refresh()
    }
    
    func fetch(_ isFiltered: Bool){
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
        let frame = self.view.bounds
        print(botPadding)
        print(view.safeAreaInsets)
        print("!")
        print(view.bounds)
        print(frame.height - frame.width / 4  - topPadding - botPadding)
        tableView.frame = CGRect(x: 0, y: 50 + topPadding, width: frame.width, height: frame.height - frame.width / 10  - topPadding - botPadding - 50)
        view.addSubview(tableView)
    }
    func setupBotButtons(buttonNum num: Int, view: UIView, systemName: String = "", named: String = ""){
        let frame = view.frame
        var img = UIImage()
        let button = UIButton()
        button.frame = CGRect(x: CGFloat(num - 1) * frame.width / 4 , y: frame.height - frame.width / 10  - topPadding - botPadding, width: frame.width / 4 + 1.5, height: frame.width / 10)
        if systemName != ""{
            let configuration = UIImage.SymbolConfiguration(pointSize: frame.width / 8)
            img = UIImage(systemName: systemName, withConfiguration: configuration) ?? UIImage()
        } else {
            img = UIImage(named: named) ?? UIImage()
        }
        button.setImage(img, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        button.backgroundColor = UIColor.systemBackground
        button.tintColor = UIColor.label

        //        button.addTarget(self, action: #selector(selectorB1), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func setupHeader(){
        let header = UIView.init(frame: CGRect.init(x: 0, y: topPadding, width: tableView.frame.width, height: 50))
        let text = UILabel()
        text.frame = CGRect.init(x: 10, y: 0, width: tableView.frame.width, height: 50)
        text.numberOfLines = 2
        text.text = "Hello, Name \nLast trainings"
        text.textAlignment = .center
        header.backgroundColor = .systemBackground
        header.layer.borderWidth = 1
        header.layer.borderColor = UIColor.label.cgColor
        view.addSubview(header)
        header.addSubview(text)
    }
    
    func setupNavBar(){
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        view.addSubview(navBar)
        
        let navItem = UINavigationItem(title: "")
        let historyItem = UIBarButtonItem(title: "History", style: .plain, target: self, action: #selector(historyItem))
        let addItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItem))
        let clockItem = UIBarButtonItem(title: "Date", style: .plain, target: self, action: #selector(clockItem))
        
        navItem.rightBarButtonItems = [addItem, clockItem, historyItem]
        navBar.setItems([navItem], animated: false)
        
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
    @objc func historyItem(){
        showHistory()
    }
    
    @objc func refresh(){
        self.tableView.reloadData()
    }
    
    func showHistory(){
        let vc = History()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: {
            vc.setExersises(self.exercises)
        })
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(exercises.count)
        return exercises.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let currentEx = exercises[indexPath.section]
        cell.textLabel?.text = data.setText(item: 1, currentEx: currentEx)
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
    
    /*
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     if section == 0{
     return nil
     } else {
     return nil
     }
     }
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                   section: Int) -> String? {
        if section == 0{
            return data.setText(item: 0, currentEx: exercises[section])
        }
        else if data.setText(item: 0, currentEx: exercises[section]) != data.setText(item: 0, currentEx: exercises[section - 1]) {
            return data.setText(item: 0, currentEx: exercises[section])
        } else {
            return nil
        }
        
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 20
        } else if data.setText(item: 0, currentEx: exercises[section]) != data.setText(item: 0, currentEx: exercises[section - 1]) {
            return 20
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let vc = AddExercise()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: {
            vc.loadObject(self.exercises[indexPath.section])
        })
        
    }
}

