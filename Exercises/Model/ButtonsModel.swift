

import UIKit

class Stepper: UIStepper{
    var name: String = ""
    func setName(name: String){
        self.name = name
    }
    func getName() -> String{
        return self.name
    }
}

class Button: UIButton{
    var num: Int = 0
    func setNum(num: Int){
        self.num = num
    }
    func getNum() -> Int{
        return self.num
    }
}

