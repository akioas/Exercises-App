

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
    var users: [NSManagedObject] = []
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch(isFiltered)
        fetchUser()
    }
    override func viewDidAppear(_ animated: Bool) {
        
        createViews()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: NSNotification.Name(rawValue: notificationKey),
                                               object: nil)
        view.backgroundColor = .secondarySystemBackground
    }
    func createViews(){
        topPadding = view.safeAreaInsets.top
        botPadding = view.safeAreaInsets.bottom
        setupTableView()
        setupHeader()
        botButtons()
        setupViews()
    }
    
    func setupViews(){
        let newView = UIView()
        newView.frame = CGRect(x: 5.0, y: tableView.frame.maxY , width: view.frame.width - 10.0, height: 1)
        newView.backgroundColor = .lightGray
        view.addSubview(newView)

        let newBotView = UIView()
        newBotView.frame = CGRect(x: 5.0, y: tableView.frame.height + topPadding , width: view.frame.width - 10.0, height: 3)
        newBotView.backgroundColor = .blue
    }
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        let frame = self.view.bounds
        tableView.frame = CGRect(x: 0, y: 50, width: frame.width, height: frame.height - frame.width / 10  - topPadding  - botPadding - 54)
        tableView.backgroundColor = .secondarySystemBackground

        view.addSubview(tableView)
    }
    
    
    func setupHeader(){
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let text = UILabel()
        text.frame = CGRect.init(x: 10, y: 0, width: tableView.frame.width, height: 50)
        text.numberOfLines = 2
        text.text = "Hello, " + yourName + "\nLast trainings"
        text.textAlignment = .center
        header.backgroundColor = .secondarySystemBackground
        header.layer.borderWidth = 1
        header.layer.borderColor = UIColor.label.cgColor
        view.addSubview(header)
        header.addSubview(text)
    }
    func botButtons(){
        let but1 = UIButton()
        let but2 = UIButton()
        let but3 = UIButton()
        let but4 = UIButton()
        setupBotButtons(but1, buttonNum: 1, view: view, systemName: "house.fill")
        setupBotButtons(but2, buttonNum: 2, view: view, named: "Dumbbell")
        setupBotButtons(but3, buttonNum: 3, view: view, systemName: "plus.circle")
        setupBotButtons(but4, buttonNum: 4, view: view, systemName: "gearshape.circle")
        but2.addTarget(self, action: #selector(toExTable), for: .touchUpInside)
        but3.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        but4.addTarget(self, action: #selector(userSettings), for: .touchUpInside)
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
    @objc func toExTable(){
        let vc = ExercisesTable()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    @objc func userSettings(){
        let vc = UserSettings()
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
    
    func fetchUser(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
    
        do {
            self.users = try context.fetch(fetchRequest)
            if let user = users.last{
                yourName = UserValues().getName(user)
            }
            
        } catch let err as NSError {
            print(err)
        }
        
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
        let newText = data.setText(item: 1, currentEx: currentEx)
        cell.textLabel?.text = newText
        if indexPath.row == 0{
            let deleteButton = Button(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            deleteButton.setNum(num: indexPath.section)
            deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
            deleteButton.tintColor = .link
            deleteButton.addTarget(self, action: #selector(deleteObject), for: .touchUpInside)
            cell.accessoryView = deleteButton
            
        } else {
            cell.accessoryView = nil
        }
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
    
   
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

