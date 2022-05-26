

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
        var points: [CGPoint] = []
        let stepSize = ( (size.width) - 20.0 ) / Double(y.count)
        print(y.count)
        
        for (index, _) in y.enumerated(){
            points.append(CGPoint(x: 20.0 + stepSize * Double(index), y: (-CGFloat((y[index])) / (size.height ) + 0.5 * (size.height) - 30.0)))
        }
         /*
        let p1 = self.bounds.origin
                let p2 = CGPoint(x:p1.x + size.width, y:p1.y)
        let p3 = CGPoint(x:p2.x, y:p2.y + size.height * 0.8)
                let p4 = CGPoint(x:size.width/2, y:size.height)
                let p5 = CGPoint(x:p1.x, y: size.height * 0.8)
        points = [p1, p2, p3, p4, p5]
*/
        let path = UIBezierPath()
        path.move(to: points.first!)
        for point in points {
            path.addLine(to: point)
        }
        print("L")
        print(points)

        UIColor.red.setStroke()
        path.lineWidth = 5
        path.stroke()
        let origPath = UIBezierPath()
        origPath.move(to: CGPoint(x: 10, y:  -Int(size.height)))
        origPath.addLine(to: CGPoint(x: 10, y: -20 + Int(size.height)))
        origPath.addLine(to: CGPoint(x: 10 + Int(stepSize) * y.count, y: -20 + Int(size.height)))
        
        UIColor.black.setStroke()
        origPath.lineWidth = 3
        origPath.stroke()
    }
}
