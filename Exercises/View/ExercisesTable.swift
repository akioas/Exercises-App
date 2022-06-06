
import UIKit
import CoreData

class ExercisesTable: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate{
    let tableView = UITableView()

    let cellId = "cellId"
    let list = ExercisesList()
    var exercises: [String] = []
    let items = Items()

    override func viewDidLoad() {
        super.viewDidLoad()
        exercises = list.load()
        self.tabBarController?.delegate = self

        
    }
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .secondarySystemBackground
        setupTableView()
        topImage(view: view, type: .common)
        setupHeader()
        self.navigationController?.isNavigationBarHidden = true

//        botButtons()
        /*
        let newView = UIView()
        newView.frame = CGRect(x: 5.0, y: tableView.frame.maxY , width: view.frame.width - 10.0, height: 1)
        newView.backgroundColor = .lightGray
        view.addSubview(newView)
*/
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {


        if viewController == (self.tabBarController?.viewControllers?[2])! {

         addItem()
          return false

        }
        return true
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
    @objc func addItem(){
        let vc = AddExercise()
        self.presentDetail(vc)

//        self.present(vc, animated: true)
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
        
        let textLabel = UILabel()
        textLabel.frame = CGRect.init(x: 10, y: 0, width: tableView.frame.width - 70, height: 50)
        textLabel.numberOfLines = 1
        textLabel.text = "Exercises"
        textLabel.font = .systemFont(ofSize: 24)

        textLabel.textAlignment = .center
        textLabel.textColor = .white
        let width = UIScreen.main.bounds.width
        let header = UIView.init(frame: CGRect.init(x: 0, y: 44, width: width, height: 50))
     
        header.backgroundColor = .clear
        
        header.addSubview(textLabel)
        let plusButton = UIButton(frame: CGRect(x: width - 60, y: 0, width: 50, height: 50))
        plusButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        plusButton.tintColor = .white
        plusButton.addTarget(self, action: #selector(displayAlert), for: .touchUpInside)
        header.addSubview(plusButton)
        
        view.addSubview(header)

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
        return 70
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

