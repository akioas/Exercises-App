
import UIKit
import CoreData

class NewExercise: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var object: Exercise? = nil
    let type = ExerciseTypes()
    var typesSave = [String]()
    var typesShow = [String]()
    var selectedType = "Cardio"
    var header = UIView()
    var isNewObject = false
    var isPicking = false
    var tableView = UITableView()
    let items = Items()
    let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .medium)
    let pickerView = UIPickerView()
    let textField = UITextField()
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        refresh()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        typesSave = type.typesSave()
        typesShow = type.typesShow()
        selectedType = typesSave.first ?? ""
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        swipeDown.delegate = self

        view.addGestureRecognizer(swipeDown)
        
        tableView.backgroundColor = .secondarySystemBackground
        tableView.frame = CGRect(x: 0, y: 50 , width: view.frame.width, height: view.frame.height - 50)
        view.addSubview(tableView)
        items.topImage(view: view, type: .common)
        setupPicker()
        textField.delegate = self
        self.hideOnTap()
    }
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .secondarySystemBackground
        setupTableView()
        header = items.setupHeader(view, text: NSLocalizedString("Add exercise", comment: ""), button: nil, imgName: nil)
    }
    
    func setObject(_ object: Exercise?, isNewObject: Bool){
        self.isNewObject = isNewObject
        if let object = object {
            self.object = object
        } else {
            cancel()
        }
        if !isNewObject {
            header.removeFromSuperview()
            header = items.setupHeader(view, text: NSLocalizedString("Edit exercise", comment: ""), button: nil, imgName: nil)
        }
    }
 
    @objc func cancel(){
        print(isNewObject)
        if isNewObject{

            if let object = object {
                AppData().deleteData(object)
            }
        }
        self.dismiss(animated: true)
    }
    @objc func done(){
        AppData().saveObjects()
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "fetch"), object: self)
        })
    }
    @objc func refresh(){
        self.tableView.reloadData()
    }
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.dataSource = self
        tableView.delegate = self
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70))
        let buttonCancel = UIButton(frame: CGRect(x: 20, y: 20, width: 100, height: 50))
        buttonCancel.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        buttonCancel.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
        buttonCancel.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        customView.addSubview(buttonCancel)
        let buttonDone = UIButton(frame: CGRect(x: view.frame.width - 120, y: 20, width: 100, height: 50))
        buttonDone.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        buttonDone.backgroundColor = .systemGray2
        buttonDone.addTarget(self, action: #selector(done), for: .touchUpInside)
        customView.addSubview(buttonDone)
        tableView.tableFooterView = customView
    }
    func setupPicker(){
        pickerView.frame = CGRect(x: 0, y: (view.frame.height - 200) / 2, width: view.frame.width, height: 150)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
    }
    @objc func showPicker(){
        isPicking = true
        view.addSubview(pickerView)
    }
    
}

extension NewExercise {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.selectionStyle = .none
        if indexPath.row == 0{
            textField.text = self.object?.name
            cell.addSubview(textField)
            textField.textColor = .black
            textField.frame = CGRect(x: 20, y: 10, width: view.frame.width - 40, height: 50)
            let editButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            editButton.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: configuration), for: .normal)
            cell.accessoryView = editButton
            editButton.isUserInteractionEnabled = false
            textField.bringSubviewToFront(view)
        } else {
            let newButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            newButton.setImage(UIImage(systemName: "list.bullet", withConfiguration: configuration), for: .normal)
            newButton.tintColor = .label
            newButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
            let contButton = UIButton(frame: cell.contentView.frame)
            contButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
            cell.contentView.addSubview(contButton)
            cell.textLabel?.text = NSLocalizedString(selectedType, comment: "")
            cell.accessoryView = newButton
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
   
}

extension NewExercise {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typesSave.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return NSLocalizedString(typesSave[row], comment: "")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = typesSave[row]
    }
}

extension NewExercise {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if (!isPicking){
            cancel()
            if let nav = navigationController {
               nav.popViewController(animated: true)
            }
        } else {
            print("ispic")
        }
    }
    @objc func hideOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(NewExercise.dismissView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissView() {
        if isPicking{
            isPicking = false
            pickerView.removeFromSuperview()
        }
        self.object?.type = selectedType
        self.object?.name = textField.text
        view.endEditing(true)

        refresh()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        object?.name = textField.text
        textField.resignFirstResponder()
        return true
    }
}

