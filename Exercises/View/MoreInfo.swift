import UIKit

class MoreInfo: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        topImage(view: view)
        let text = UILabel()
        text.frame = CGRect.init(x: 20, y: 20, width: view.frame.width, height: view.frame.height)
        text.text = "Здесь скоро будет волшебство"
        text.textColor = .black
        text.font = .systemFont(ofSize: 24)
        view.addSubview(text)
    }
    
    
}
