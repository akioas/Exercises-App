

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
    let items = Items()
    var date = Date()
    var selected = ""
    let cellId = "cellId"
    var exercises: [NSManagedObject] = []
    var users: [NSManagedObject] = []
    let textLabel = UILabel()

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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(newHeader),
                                               name: NSNotification.Name(rawValue: "header"),
                                               object: nil)
        view.backgroundColor = .secondarySystemBackground
//        self.hideOnTap()

    }
    func createViews(){
        topPadding = view.safeAreaInsets.top
        botPadding = view.safeAreaInsets.bottom
        setupTableView()
        setupHeader(view, text: ("Hello, " + yourName + "\nLast trainings"), width: tableView.frame.width)
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
    
    
    
    func botButtons(){
        let but1 = UIButton()
        let but2 = UIButton()
        let but3 = UIButton()
        let but4 = UIButton()
        items.setupBotButtons(but1, buttonNum: 1, view: view, systemName: "house.fill", isCore: true)
        items.setupBotButtons(but2, buttonNum: 2, view: view, named: "Dumbbell", isCore: true)
        items.setupBotButtons(but3, buttonNum: 3, view: view, systemName: "plus.circle", isCore: true)
        items.setupBotButtons(but4, buttonNum: 4, view: view, systemName: "gearshape.circle", isCore: true)
        but2.addTarget(self, action: #selector(toExTable), for: .touchUpInside)
        but3.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        but4.addTarget(self, action: #selector(userSettings), for: .touchUpInside)
    }
    func setupHeader(_ view: UIView, text: String, width: CGFloat){
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 50))
        textLabel.frame = CGRect.init(x: 10, y: 0, width: width - 100, height: 50)
        textLabel.numberOfLines = 2
        textLabel.text = text
        textLabel.textAlignment = .center
        header.backgroundColor = .secondarySystemBackground
        header.layer.borderWidth = 1
        header.layer.borderColor = UIColor.label.cgColor
        header.addSubview(textLabel)
        let calButton = UIButton(frame: CGRect(x: width - 50, y: 0, width: 50, height: 50))
        calButton.setImage(UIImage(systemName: "calendar"), for: .normal)
        calButton.tintColor = .link
        calButton.addTarget(self, action: #selector(clockItem), for: .touchUpInside)
        header.addSubview(calButton)

        view.addSubview(header)
    }
    func createDatePicker(){
        
        datePicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.backgroundColor = .secondarySystemBackground
        setupDatePicker(datePicker: datePicker, toolBar: toolBar)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDate))
        let spaceButton = UIBarButtonItem(title: "Clear selection", style: .plain, target: self, action: #selector(clearDate))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDate))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        view.addSubview(toolBar)
        view.addSubview(datePicker)
    }
    
}

extension ViewController {
    
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
        createDatePicker()
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
  
        setDate(datePicker.date)
        cancelDate()
    }
    @objc func clearDate(){
        isFiltered = false
        fetch(isFiltered)
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
                if yourName == "Not set"{
                    yourName = "User"
                }
            }
            
        } catch let err as NSError {
            print(err)
        }
        
    }
    
    @objc func newHeader(){
        textLabel.text = ("Hello, " + yourName + "\nLast trainings")
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

/*
extension ViewController {

    @objc func hideOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(ViewController.dismissView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissView() {
        if let _ = datePicker{
            doneDate()
        }
    }
}
 */
