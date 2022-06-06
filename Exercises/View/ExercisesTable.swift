
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
        setupHeader(view, text: "Exercises", button: plusButton, imgName: "plus.circle")
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
        
        let alertController = UIAlertController(title: "Добавить упражнение", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Упражнение"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.exercises.insert(firstTextField.text ?? "", at: self.exercises.endIndex)
            self.list.save(self.exercises)
            self.refresh()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        
        
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
        
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

