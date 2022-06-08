
/*
import UIKit
import CoreData

class Chart: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var exersises: [NSManagedObject] = []
    let data = GetData()
    var dates: [String] = []
    var rep: [Int16] = []
    var reps: [Int16] = []
    var weights: [Int16] = []
    let types = ["rep", "reps", "weights"]
    var selectedType = "rep"
    var previousSelection = "rep"
    let picker = UIPickerView()
    let toolBar = UIToolbar()
    let label = UILabel()
    let chart = ChartView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
    }
    
    func setValues(_ exersises: [NSManagedObject]){
        self.exersises = exersises
        makeLine()
        setupNavBar()

    }
    func makeLine(){
        getPoints()

        if exersises.count < 1{
            let img = UIImage(systemName: "sparkle")!
            let width = UIScreen.main.bounds.width - 30
            let frame = CGRect(x: 0, y: (UIScreen.main.bounds.height - width) / 2, width: width, height: width)
            let imgView = UIImageView(frame: frame)
            view.addSubview(imgView)
            imgView.image = img
            print(imgView.frame)
        } else if exersises.count > 1{
            let width = UIScreen.main.bounds.width

            let frame = CGRect(x: 0, y: (UIScreen.main.bounds.height - width) / 2, width: width, height: width)
            chart.frame = frame
            chart.y = reps
            self.view.addSubview(chart)
            chart.layer.borderWidth = 10
            chart.layer.borderColor = UIColor.red.cgColor
            label.frame = CGRect(x: 10, y: (UIScreen.main.bounds.height - width) / 2 + width + 10, width: width, height: 100)
            var txt = (dates.first ?? "") + " --- " + "\n" + (dates.last ?? "")
            txt = txt + "\n" +
            "min " + String(Int(reps.min() ?? 0)) + " --- max " + String(Int(reps.max() ?? 0))
            label.textColor = .systemIndigo
            label.text = txt
            label.numberOfLines = 3

            self.view.addSubview(label)

        } else {
            let width = UIScreen.main.bounds.width - 30
            let frame = CGRect(x: 20, y: (UIScreen.main.bounds.height - width) / 2, width: width, height: width)
            let txtField = UILabel(frame: frame)
            let txt = String(dates.first!) + "\nRep: " + String(rep.first!) + "\nReps:" +
            String(reps.first!) + "\nWeights:" + String(weights.first!)
            txtField.text = txt
            txtField.textColor = .systemIndigo
            txtField.numberOfLines = 4
            view.addSubview(txtField)
            
            print("d")
        }
    }
    func getPoints(){
        for ex in exersises{
            dates.append(data.caseDate(ex))
            rep.append(data.getRep(currentEx: ex))
            reps.append(data.getReps(currentEx: ex))
            weights.append(Int16(data.getWeight(currentEx: ex)))
        }
        print(dates)
        print(rep)
        print(weights)
    }
    func setupNavBar(){
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let navItem = UINavigationItem(title: "")
        let backItem = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(back))
        
        navItem.leftBarButtonItems = [backItem]
        if dates.count > 1{
            let chooseItem = UIBarButtonItem(title: "choose type", style: .plain, target: self, action: #selector(choose))
            navItem.rightBarButtonItems = [chooseItem]
        }
        
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
        print(navBar.frame)
    }
    @objc func back(){
        self.dismiss(animated: false)
    }
    @objc func choose(){
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .secondarySystemBackground
        picker.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 200)
        view.addSubview(picker)
        previousSelection = selectedType
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        view.addSubview(toolBar)
        
    }
    
    @objc func cancelPicker() {
        selectedType = previousSelection
        removePicker()
    }
    @objc func donePicker() {
        var txt = ""
        txt = (dates.first ?? "") + " --- " + "\n" + (dates.last ?? "")
        if selectedType == "reps"{
            chart.y = reps
            txt = txt + "\n" +
            "min " + String(Int(reps.min() ?? 0)) + " --- max " + String(Int(reps.max() ?? 0))
        } else if selectedType == "rep"{
            chart.y = rep
            txt = txt + "\n" +
            "min " + String(Int(rep.min() ?? 0)) + " --- max " + String(Int(rep.max() ?? 0))
        } else {
            txt = txt + "\n" +
            "min " + String(Int(weights.min() ?? 0)) + " --- max " + String(Int(weights.max() ?? 0))
            chart.y = weights
        }
        label.text = txt
        chart.setNeedsDisplay()
   
        removePicker()

    }
    
    func removePicker(){
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
}

extension Chart{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = types[row]
    }
}

class ChartView : UIView {
    var y: [Int16] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        let size = self.bounds.size
        let height = size.height - 10.0
        var points: [CGPoint] = []
        let stepSize = ( (size.width) ) / Double(y.count)
        print(y.count)
        let diff = Int(y.max() ?? 0) - Int(y.min() ?? 0)
        var stepY = 0.0
        if diff != 0{
            stepY = 0.4 * height / CGFloat(diff)
        }
        print("d")
        print(stepY)
        print(CGFloat(diff))
        print(height)
        let yMin = Int(y.min() ?? 0)
        for (index, _) in y.enumerated(){
            points.append(CGPoint(x: 20.0 + stepSize * Double(index), y:    height + stepY * (-CGFloat(y[index]) )))
            print(points)
        }
        let path = UIBezierPath()
        path.move(to: points.first!)
        for point in points {
            path.addLine(to: point)
        }
        UIColor.red.setStroke()
        path.lineWidth = 5
        path.stroke()
        print(points)
           
    }
}
*/
