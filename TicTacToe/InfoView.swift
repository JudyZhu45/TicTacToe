import UIKit

class InfoView: UIView {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 使用 CALayer 设置外观
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.masksToBounds = true
        self.backgroundColor = .white
    }
}
