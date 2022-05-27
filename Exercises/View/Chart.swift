

import UIKit
import CoreData

class Chart: UIViewController{
    
    var exersises: [NSManagedObject] = []
    let data = GetData()
    var dates: [String] = []
    var rep: [Int16] = []
    var reps: [Int16] = []
    var weights: [Int16] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavBar()
    }
    
    func setValues(_ exersises: [NSManagedObject]){
        self.exersises = exersises
        makeLine()
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
            let width = UIScreen.main.bounds.width - 30

            let frame = CGRect(x: 0, y: (UIScreen.main.bounds.height - width) / 2, width: width, height: width)

            let chart = ChartView(frame: frame)
            chart.y = reps
            self.view.addSubview(chart)

        } else {
            let width = UIScreen.main.bounds.width - 30
            let frame = CGRect(x: 20, y: (UIScreen.main.bounds.height - width) / 2, width: width, height: width)
            let txtField = UILabel(frame: frame)
            let txt = String(dates.first!) + "\nRep: " + String(rep.first!) + "\nReps:" +
            String(reps.first!) + "\nWeights:" + String(weights.first!)
            txtField.text = txt
            txtField.textColor = .systemIndigo
            print(txt)
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
            weights.append(data.getWeight(currentEx: ex))
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
        
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
        print(navBar.frame)
    }
    @objc func back(){
        self.dismiss(animated: false)
    }
}

class ChartView : UIView {
    var y: [Int16] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        let size = self.bounds.size
        let height = size.height - 10.0
        var points: [CGPoint] = []
        let stepSize = ( (size.width) - 20.0 ) / Double(y.count)
        print(y.count)
        let diff = Int(y.max() ?? 0) - Int(y.min() ?? 0)
        print(diff)
        let stepY = 100*CGFloat(diff) / height
        print("d")
        print(stepY)
        print(CGFloat(diff))
        print(height)
        let yMin = Int(y.min() ?? 0)
        for (index, _) in y.enumerated(){
            points.append(CGPoint(x: 20.0 + stepSize * Double(index), y: -40 + height + stepY * (-CGFloat(y[index]) )))
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
        
        let origPath = UIBezierPath()
        origPath.move(to: CGPoint(x: 10, y:  -Int(size.height)))
        origPath.addLine(to: CGPoint(x: 10, y: -20 + Int(height)))
        origPath.addLine(to: CGPoint(x: 10 + Int(stepSize) * y.count, y: -20 + Int(height)))
        
        UIColor.black.setStroke()
        origPath.lineWidth = 3
        origPath.stroke()
    }
}
