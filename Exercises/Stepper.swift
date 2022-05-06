

import UIKit

class Stepper: UIStepper{
    var num: Int = 0
    var name: String = ""
    func setNum(num: Int){
        self.num = num
    }
    func setName(name: String){
        self.name = name
    }
    func getNum() -> Int{
        return self.num
    }
    func getName() -> String{
        return self.name
    }
    
}
