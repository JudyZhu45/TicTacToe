import UIKit

class GridView: UIView {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let width = rect.width
        let height = rect.height
        
        // 两条纵线
        for i in 1...2 {
            let x = CGFloat(i) * width / 3
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: height))
        }
        
        // 两条横线
        for i in 1...2 {
            let y = CGFloat(i) * height / 3
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: width, y: y))
        }
        
        path.lineWidth = 5
        UIColor.black.setStroke()
        path.stroke()
    }
}
