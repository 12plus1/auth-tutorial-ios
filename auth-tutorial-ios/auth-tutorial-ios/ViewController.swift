import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var successLabel: UILabel!
    
    @IBAction func authenticate(_ sender: Any) {
        loginButton.isHidden = true
        successLabel.isHidden = false
    }
}

