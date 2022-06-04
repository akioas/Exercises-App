
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
        setupHeader()
//        botButtons()
        /*
        let newView = UIView()
        newView.frame = CGRect(x: 5.0, y: tableView.frame.maxY , width: view.frame.width - 10.0, height: 1)
        newView.backgroundColor = .lightGray
        view.addSubview(newView)
*/
    }
    func botButtons(){
        let but1 = UIButton()
        let but2 = UIButton()
        let but3 = UIButton()
        let but4 = UIButton()
        items.setupBotButtons(but1, buttonNum: 1, view: view, systemName: "house.fill")
        items.setupBotButtons(but2, buttonNum: 2, view: view, named: "Dumbbell")
        items.setupBotButtons(but3, buttonNum: 3, view: view, systemName: "plus.circle")
        items.setupBotButtons(but4, buttonNum: 4, view: view, systemName: "gearshape.circle")
        but1.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        but3.addTarget(self, action: #selector(addNewEx), for: .touchUpInside)
        but4.addTarget(self, action: #selector(userSettings), for: .touchUpInside)
    }
    
    @objc func cancel(){
        self.dismiss(animated: false)
    }
    @objc func userSettings(){
        
            weak var pvc = self.presentingViewController

            self.dismiss(animated: false, completion: {
                let vc = UserSettings()
                vc.modalPresentationStyle = .fullScreen
                pvc?.present(vc, animated: false, completion: nil)
            })
            
        
        
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
    func setupHeader(){
//        let header = UIView.init(frame: CGRect.init(x: 0, y: topPadding, width: tableView.frame.width, height: 50))
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 44, width: view.frame.size.width, height: 44))
        self.navigationController?.view.addSubview(navBar)

        let navItem = UINavigationItem()
        let clock = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(displayAlert))
        navItem.rightBarButtonItem = clock

        navBar.setItems([navItem], animated: false)
        let text = UILabel()
        text.frame = CGRect.init(x: 10, y: 0, width: tableView.frame.width - 90, height: 50)
        text.numberOfLines = 1
        text.text = "Exercises"
        text.textAlignment = .center
        navBar.addSubview(text)

        /*
        header.backgroundColor = .secondarySystemBackground
        header.layer.borderWidth = 1
        header.layer.borderColor = UIColor.label.cgColor
        view.addSubview(header)
        let button = UIButton()
        button.frame = CGRect(x: tableView.frame.width - 100, y: 0, width: 100, height: 50)
        let configuration = UIImage.SymbolConfiguration(pointSize: view.frame.width / 15)
        let img = UIImage(systemName: "plus.circle", withConfiguration: configuration) ?? UIImage()
        button.setImage(img, for: .normal)
        button.tintColor = .label
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(displayAlert), for: .touchUpInside)
        header.addSubview(button)
         */

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
        return 20
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

