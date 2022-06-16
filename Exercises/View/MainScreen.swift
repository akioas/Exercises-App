

import UIKit
import CoreData
import NotificationCenter

let notificationKey = "Key"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UITabBarControllerDelegate {
    let tableView = UITableView()
    var datePicker : UIDatePicker!
    let toolBar = UIToolbar()
    
    var isFiltered = false
    let data = GetData()
    let items = Items()
    var date = Date()
    var selected = ""
    let cellId = "cellId"
    var exercises = [ExerciseSet]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch(isFiltered)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if !UserVariables().isFirstLaunch(){ //!
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "launch") as! FirstLaunch
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
        createViews()
        
        if let tabBar = self.tabBarController?.tabBar{
            setupTabBar(tabBar)
          
        }
        self.tabBarController?.delegate = self
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        if viewController == (self.tabBarController?.viewControllers?[2])! {

         addItem()
          return false

        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: NSNotification.Name(rawValue: notificationKey),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchObs),
                                               name: NSNotification.Name(rawValue: "fetch"),
                                               object: nil)
        
        view.backgroundColor = .secondarySystemBackground

       
    }
    func createViews(){
        topPadding = view.safeAreaInsets.top
        botPadding = view.safeAreaInsets.bottom

        setupTableView()

        topImage(view: view, type: .common)
        let calButton = UIButton()
        _ = setupHeader(view, text: NSLocalizedString("Last trainings", comment: ""), button: calButton, imgName: "calendar")
        calButton.addTarget(self, action: #selector(clockItem), for: .touchUpInside)

        self.navigationController?.isNavigationBarHidden = true

    }
    
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        let frame = view.bounds
        tableView.frame = CGRect(x: 0, y: 70 + 44, width: frame.width, height: frame.height - 50   )
        tableView.backgroundColor = .secondarySystemBackground
        view.addSubview(tableView)
    }
    
    
   
    
    func createDatePicker(){
        
        datePicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        setupDatePicker(datePicker: datePicker, toolBar: toolBar)
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Select", comment: ""), style: .plain, target: self, action: #selector(doneDate))
        let spaceButton = UIBarButtonItem(title: NSLocalizedString("Clear selection", comment: ""), style: .plain, target: self, action: #selector(clearDate))
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelDate))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolBar.setItems([cancelButton, flexibleSpace, spaceButton, flexibleSpace, doneButton], animated: false)
        self.navigationController?.view.addSubview(toolBar)

        view.addSubview(datePicker)
    }
    
}

extension ViewController {
    
    func deleteLast(_ object: ExerciseSet){
        DataModel().delete(object)
        refresh()
    }
    @objc func fetchObs(){
        fetch(isFiltered)
    }
    func fetch(_ isFiltered: Bool){
        let fetchRequest = fetchRequest(isFiltered: isFiltered, date: date)
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "addex") as! AddExercise
        vc.isModalInPresentation = true

        self.present(vc, animated: true)
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
    @objc func refresh(){
        self.tableView.reloadData()
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
        refresh()
        tableView.beginUpdates()
        tableView.deleteSections(IndexSet([sender.num]), with: .fade)
        deleteData(exercises[sender.num])
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
            return 40
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "addex") as! AddExercise
        vc.isModalInPresentation = true

        self.present(vc, animated: true, completion: {
            vc.loadObject(self.exercises[indexPath.section])
        })
        
    }
}
