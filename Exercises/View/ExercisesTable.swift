
import UIKit
import CoreData

class ExercisesTable: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let tableView = UITableView()

    let cellId = "cellId"
    let list = ExercisesList()
    var exercises: [String] = []
    let items = Items()

    override func viewDidLoad() {
        super.viewDidLoad()
        exercises = list.load()
    }
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .secondarySystemBackground
        setupTableView()
        topImage(view: view, type: .common)
        let plusButton = UIButton()
        setupHeader(view, text: NSLocalizedString("Exercises", comment: ""), button: plusButton, imgName: "plus.circle")
        plusButton.addTarget(self, action: #selector(displayAlert), for: .touchUpInside)
        self.navigationController?.isNavigationBarHidden = true

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
    
    
    @objc func refresh(){
        self.tableView.reloadData()
    }
    @objc func displayAlert() {
        
        let alertController = UIAlertController(title: NSLocalizedString("Add exercise", comment: ""), message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = NSLocalizedString("Exercise", comment: "")
        }
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.exercises.insert(firstTextField.text ?? "", at: self.exercises.endIndex)
            self.list.save(self.exercises)
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
            textField.text = self.exercises[sender.num]
        }
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.exercises[sender.num] = firstTextField.text ?? ""
            self.list.save(self.exercises)
            self.refresh()
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func deleteObject(_ sender:Button!){
        self.exercises.remove(at: sender.num)
        self.list.save(self.exercises)
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
        cell.textLabel?.text = exercises[indexPath.row]
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

