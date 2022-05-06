

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    let cellId = "cellId"
    var exercises: [NSManagedObject] = []
    var callBackStepper:((_ value:Int, _ num: Int, _ name: String)->())?


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
        
    }
    
    func fetch(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
            do {
                exercises = try context.fetch(fetchRequest)
                print(exercises)
            } catch let err as NSError {
                print(err)
            }
            tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray
        
        let tableView = UITableView()
        view.addSubview(tableView)
        setupTableView()
//        tableView.register(TableViewCell.self, forCellReuseIdentifier:cellId)

        self.tableView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        setupButton()
        
    }
    
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func setupButton(){
        let button = UIButton(frame: CGRect(x: 40, y: 100, width: UIScreen.main.bounds.width - 80, height: 50))
        button.backgroundColor = .systemIndigo
        button.setTitle("Добавить", for: .normal)
        button.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        
        self.view.addSubview(button)
        button.frame.origin.y = -60
    }
    
    @objc func addItem(){
        DataModel().addModel()
        fetch()
    }
    
    @objc func stepperValueChanged(_ sender:Stepper!)
        {
            callBackStepper?(Int(sender.value), sender.getNum(), sender.getName())
        }
   
     
}

extension ViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return exercises.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let currentEx = exercises[indexPath.section]
        
        cell.textLabel?.text = setText(item: (indexPath.item), currentEx: currentEx)
//        let newButton = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        newButton.setImage(UIImage(systemName: "doc.fill"), for: .normal)

//        let accessoryView = newButton
        if indexPath.row == 2{
            setupStepper(cell, tag: indexPath.section, value: Double((getRep(currentEx: currentEx))), name: "rep")
            callBack()
        } else if (indexPath.row == 3){
            setupStepper(cell, tag: indexPath.section, value: Double((getReps(currentEx: currentEx))), name: "reps")
            callBack()
        } else if (indexPath.row == 4){
            setupStepper(cell, tag: indexPath.section, value: Double((getWeight(currentEx: currentEx))), name: "weight")
            callBack()
        } else {
            cell.accessoryView = nil
        }
        return cell
    }
    
    func callBack(){
        callBackStepper = { value, num, name in
            let currentEx = self.exercises[num]
            currentEx.setValue(value, forKey: name)
            DataModel().saveModel()
            self.tableView.reloadData()
        }
    }
        
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 5
        }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return UIView()
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }

    func setupStepper(_ cell: UITableViewCell, tag: Int, value: Double, name: String){
        let stepper = Stepper()
        stepper.minimumValue = 0
        stepper.maximumValue = 10
        stepper.value = value
        stepper.stepValue = 1
        stepper.setNum(num: tag)
        stepper.setName(name: name)
        stepper.addTarget(self, action: #selector(self.stepperValueChanged(_:)), for: .valueChanged)
        cell.accessoryView = stepper
    }

}


