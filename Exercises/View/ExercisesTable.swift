
import UIKit
import CoreData

class ExercisesTable: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    let tableView = UITableView()

    let cellId = "cellId"
    let list = GetExercises()
    var exercises = [Exercise]()
    let items = Items()
    let vcPicker = UIViewController()
    let type = ExerciseTypes()
    var typesSave = ["Cardio",
                 "Strength"]
    var typesShow = [NSLocalizedString("Cardio", comment: ""),
                 NSLocalizedString("Strength", comment: "")]
    var selectedType = "Cardio"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: NSNotification.Name(rawValue: "fetch"),
                                               object: nil)
        typesSave = type.typesSave()
        typesShow = type.typesShow()
        selectedType = typesSave.first ?? ""
    
    }
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .secondarySystemBackground
        setupTableView()
        items.topImage(view: view, type: .common)
        let plusButton = UIButton()
        _ = items.setupHeader(view, text: NSLocalizedString("Exercises", comment: ""), button: plusButton, imgName: "plus.circle")
        plusButton.addTarget(self, action: #selector(displayAlert), for: .touchUpInside)
        self.navigationController?.isNavigationBarHidden = true
        setupPicker()
    }
    func setupPicker(){
        vcPicker.preferredContentSize = CGSize(width: 250,height: 200)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        vcPicker.view.addSubview(pickerView)
    }
    @objc func cancel(){
        self.dismiss(animated: false)
    }
    
    @objc func addNewEx(){
        let vc = AddExercise()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }

    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        let frame = self.view.bounds

        tableView.frame = CGRect(x: 0, y: 50 , width: frame.width, height: frame.height - 50)
        tableView.isUserInteractionEnabled = true
        tableView.backgroundColor = .secondarySystemBackground
        view.addSubview(tableView)
       
    }
    
    func fetch(){
        let fetchRequest = NSFetchRequest<Exercise>(entityName: "Exercise")
    
        do {
            self.exercises = try context.fetch(fetchRequest)
              
        } catch let err as NSError {
            print(err)
        }
        
    }
    @objc func refresh(){
        AppData().saveObjects()
        fetch()
        self.tableView.reloadData()
    }
    @objc func displayAlert() {
        
        let alertController = UIAlertController(title: NSLocalizedString("Add exercise", comment: ""), message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = NSLocalizedString("Exercise", comment: "")
        }
        alertController.setValue(vcPicker, forKey: "contentViewController")
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            let newEx = self.list.add()
            newEx.name = firstTextField.text ?? ""
            newEx.type = self.selectedType

            self.refresh()
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    @objc func editObject(_ sender:Button!) {
        
        let alertController = UIAlertController(title: NSLocalizedString("Edit exercise", comment: ""), message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = NSLocalizedString("Exercise", comment: "")
            textField.text = self.exercises[sender.num].name
        }
        alertController.setValue(vcPicker, forKey: "contentViewController")
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.exercises[sender.num].name = firstTextField.text ?? ""
            self.exercises[sender.num].type = self.selectedType
            self.refresh()
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func deleteObject(_ sender:Button!){
        AppData().deleteData(exercises[sender.num])
        self.refresh()
    }
}



extension ExercisesTable {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
   

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = (exercises[indexPath.row].name ?? "") + ", " + (exercises[indexPath.row].type ?? "")
        cell.backgroundColor = .secondarySystemBackground
        let deleteButton = Button(frame: CGRect(x: 50, y: 0, width: 50, height: 50))
        deleteButton.setNum(num: indexPath.row)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .link
        deleteButton.addTarget(self, action: #selector(deleteObject), for: .touchUpInside)
        let editButton = Button(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        editButton.setNum(num: indexPath.row)
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.tintColor = .link
        editButton.addTarget(self, action: #selector(editObject), for: .touchUpInside)
        let buttons = UIView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 50))
        buttons.addSubview(deleteButton)
        buttons.addSubview(editButton)
        cell.accessoryView = buttons
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension ExercisesTable {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typesSave.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typesShow[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = typesSave[row]
    }
}
