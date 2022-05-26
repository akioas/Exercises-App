

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
