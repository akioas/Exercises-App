import UIKit
import CoreData
import NotificationCenter


class Picker: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var callBackPicker:((_ value: Exercise, _ currentEx: ExerciseSet)->())?
    
    var picker  = UIPickerView()
    var toolBar = UIToolbar()
    var selected: Exercise? = nil
    var pickerNum = 0
    var object: ExerciseSet? = nil
    let list = ExercisesList()
    var exercises: [Exercise] = []
    var exercisesString = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        self.hideOnTap()
   
        callBackPicker = { value, currentEx in
            currentEx.exercise = value
            AppData().saveObjects()
        }
        
        self.view.backgroundColor = .clear
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .white
        picker.contentMode = .center
           
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.backgroundColor = .secondarySystemBackground
        
        toolBar.frame = CGRect.init(x: 0.0, y: (UIScreen.main.bounds.size.height - 300)  - 50, width: UIScreen.main.bounds.size.width, height: 50)
        picker.frame = CGRect.init(x: 0.0, y: (UIScreen.main.bounds.size.height - 300) , width: UIScreen.main.bounds.size.width, height: 200)
        
        view.addSubview(picker)
        view.addSubview(toolBar)
       
        if let indexPosition = exercisesString.firstIndex(of: list.loadRow() ?? ""){
           picker.selectRow(indexPosition, inComponent: 0, animated: true)
         }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    func fetch(){
        let fetchRequest = NSFetchRequest<Exercise>(entityName: "Exercise")
    
        do {
            self.exercises = try context.fetch(fetchRequest)
              
        } catch let err as NSError {
            print(err)
        }
        for ex in exercises{
            exercisesString.append(ex.name ?? "")
        }
    }
    func setNum(_ num: Int, ex: ExerciseSet){
        pickerNum = num
        object = ex
    }
    
    @objc func cancelPicker() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshAdd"), object: self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NotPicking"), object: self)

        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    @objc func dismissPicker() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NotPicking"), object: self)
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        if let object = object {
            DataModel().delete(object)
        }
    }
    @objc func donePicker(){
        if let selected = selected {
            if let object = object{
                callBackPicker?(selected, object)
            }
        }
        cancelPicker()
    }
    
    
}

extension Picker{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        exercises.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (exercises[row].name ?? "") + ", " + (NSLocalizedString(exercises[row].type ?? "", comment: ""))
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = exercises[row]
    }
}

extension Picker {

    @objc func hideOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(Picker.dismissView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissView() {
        list.saveRow(selected?.name ?? "")
        donePicker()
    }
}
