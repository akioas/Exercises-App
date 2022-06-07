import UIKit

extension UITextField {
    func leftSpace(_ width: CGFloat){
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
}
