import UIKit

class ViewController: UIViewController {
    let grid = Grid()
    var currentPlayer: Player = .x   // 追踪当前是谁的轮次 (X 或 O)
    var isGameOver = false           // 记录游戏是否结束
    
    // 记录 X 和 O 的初始位置（用于没投进时弹回原位）
    var xInitialCenter: CGPoint = .zero
    var oInitialCenter: CGPoint = .zero
    // 插座 1：九宫格的集合
    @IBOutlet var dropZones: [UIView]!
    
//    // 插座 2：游戏角色的 Label
    @IBOutlet weak var playerXLabel: UILabel!
    @IBOutlet weak var playerOLabel: UILabel!
//    
//    // 插座 3：弹出的信息视图
   @IBOutlet weak var infoView: InfoView!
   @IBOutlet weak var info: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. 保存 X 和 O 的初始位置
        xInitialCenter = playerXLabel.center
        oInitialCenter = playerOLabel.center
        
        // 2. 初始化时只让 O 半透明，X 保持高亮
        playerXLabel.alpha = 1.0
        playerOLabel.alpha = 0.5
        
        // 3. 开始时只有 X 可以被拖动
        playerXLabel.isUserInteractionEnabled = true
        playerOLabel.isUserInteractionEnabled = false
        
        // 4. 隐藏信息弹窗（放到屏幕上方）
        infoView.center = CGPoint(x: view.center.x, y: -200)
        
        // 5. 开始第一回合，给 X 一个动画提示
        startTurn(for: .x)
    }
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        // 1. 弹窗掉落到屏幕下方消失
        UIView.animate(withDuration: 0.4, animations: {
            self.infoView.center = CGPoint(x: self.view.center.x, y: self.view.frame.height + 300)
        }) { _ in
            // 2. 动画结束后重置游戏
            self.resetGame()
        }
    }
    // 动作插座：处理拖拽手势
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let piece = sender.view else { return }
        let translation = sender.translation(in: view)
        
        // 1. 随手指移动
        if sender.state == .began || sender.state == .changed {
            piece.center = CGPoint(x: piece.center.x + translation.x, y: piece.center.y + translation.y)
            sender.setTranslation(.zero, in: view)
            
            // 实时检查是否在某个格子上方，进行高亮
            updateZoneHighlight(for: piece)
        }
        
        // 2. 手指松开 - 检查是否触发了某个格子
        if sender.state == .ended {
            var didSnap = false
            
            // 遍历所有格子
            for (index, zone) in dropZones.enumerated() {
                // 获取 zone 在主 view 坐标系中的位置
                guard let gridView = zone.superview else { continue }
                let zoneFrameInView = gridView.convert(zone.frame, to: view)
                
                // 检查 piece 中心是否在 zone 内
                if zoneFrameInView.contains(piece.center) {
                    // Check if position is already occupied
                    if !grid.isSquareEmpty(at: index) {
                        // Position occupied - show forbidden hint
                        showForbiddenHint()
                    } else {
                        // 成功放置！在 zone 中生成副本
                        guard let sourceLabel = piece as? UILabel else { return }
                        
                        let copiedLabel = UILabel()
                        copiedLabel.text = sourceLabel.text
                        copiedLabel.font = sourceLabel.font
                        copiedLabel.textColor = sourceLabel.textColor
                        copiedLabel.textAlignment = .center
                        copiedLabel.sizeToFit()
                        
                        // 把副本放在 zone 的中心（在主 view 坐标系中）
                        copiedLabel.center = CGPoint(
                            x: zoneFrameInView.midX,
                            y: zoneFrameInView.midY
                        )
                        view.addSubview(copiedLabel)
                        
                        // 记录游戏数据
                        grid.occupies(at: index, with: currentPlayer)
                        didSnap = true
                        
                        // 原始 piece 弹回初始位置
                        UIView.animate(withDuration: 0.3) {
                            piece.center = (self.currentPlayer == .x) ? self.xInitialCenter : self.oInitialCenter
                        }
                        
                        // 检查游戏状态
                        checkGameStatus()
                    }
                    
                    // 清除所有高亮
                    clearZoneHighlights()
                    break
                }
            }
            
            // 没有成功放置，弹回原位
            if !didSnap {
                UIView.animate(withDuration: 0.3) {
                    piece.center = (self.currentPlayer == .x) ? self.xInitialCenter : self.oInitialCenter
                }
                // 清除高亮
                clearZoneHighlights()
            }
        }
    }
    
    // 更新格子高亮状态
    private func updateZoneHighlight(for piece: UIView) {
        for (index, zone) in dropZones.enumerated() {
            guard let gridView = zone.superview else { continue }
            let zoneFrameInView = gridView.convert(zone.frame, to: view)
            
            if zoneFrameInView.contains(piece.center) {
                // piece is over this zone
                if grid.isSquareEmpty(at: index) {
                    // Can place - green highlight
                    highlightZone(zone, with: UIColor.green.withAlphaComponent(0.3))
                } else {
                    // Occupied - red highlight
                    highlightZone(zone, with: UIColor.red.withAlphaComponent(0.3))
                }
            } else {
                // Remove highlight from this zone
                clearZoneHighlight(zone)
            }
        }
    }
    
    // Highlight a single zone
    private func highlightZone(_ zone: UIView, with color: UIColor) {
        if zone.backgroundColor == color {
            return // Already this color, no need to reset
        }
        zone.backgroundColor = color
    }
    
    // Clear highlight from a single zone
    private func clearZoneHighlight(_ zone: UIView) {
        zone.backgroundColor = UIColor(white: 0, alpha: 0)
    }
    
    // Clear highlights from all zones
    private func clearZoneHighlights() {
        for zone in dropZones {
            clearZoneHighlight(zone)
        }
    }
    
    // Show forbidden hint
    private func showForbiddenHint() {
        let forbidLabel = UILabel()
        forbidLabel.text = "❌ Position Occupied"
        forbidLabel.textColor = .white
        forbidLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        forbidLabel.textAlignment = .center
        forbidLabel.backgroundColor = UIColor(red: 1, green: 0.2, blue: 0.2, alpha: 0.8)
        forbidLabel.layer.cornerRadius = 8
        forbidLabel.layer.masksToBounds = true
        forbidLabel.sizeToFit()
        forbidLabel.frame = CGRect(x: 0, y: 0, width: forbidLabel.frame.width + 30, height: 45)
        forbidLabel.center = CGPoint(x: view.center.x, y: 100)
        
        view.addSubview(forbidLabel)
        
        // Auto remove after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIView.animate(withDuration: 0.3, animations: {
                forbidLabel.alpha = 0
            }) { _ in
                forbidLabel.removeFromSuperview()
            }
        }
    }
    func checkGameStatus() {
        // 1. Check if there is a winner
        if let winner = grid.checkWinner() {
            isGameOver = true
            let winnerName = (winner == .x) ? "X Wins!" : "O Wins!"
            showInfo(with: winnerName)
            
        }
        // 2. Check if it's a tie
        else if grid.isTie() {
            isGameOver = true
            showInfo(with: "Draw!")
            
        }
        // 3. Game continues, switch player
        else {
            switchPlayer()
        }
    }
    func showInfo(with message: String) {
        // 1. 设置文字
        info.text = message
        
        // 2. 把 infoView 移到最上方（确保不被其他视图挡住）
        view.bringSubviewToFront(infoView)
        
        // 3. 确保它在动画开始前处于屏幕上方
        infoView.center = CGPoint(x: view.center.x, y: -200)
        
        // 4. 掉落动画：使用弹簧效果
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.infoView.center = self.view.center // 移动到画面中心
        }, completion: nil)
    }
    func resetGame() {
        // 1. 模型清空
        grid.reset()
        isGameOver = false
        currentPlayer = .x
        
        // 2. 清除格子里放置的所有副本 (除了原始的 playerXLabel 和 playerOLabel)
        for subview in view.subviews {
            if subview is UILabel && subview != playerXLabel && subview != playerOLabel && subview != info {
                subview.removeFromSuperview()
            }
        }
        
        // 3. 把 X 和 O 标签移回它们最初的位置
        UIView.animate(withDuration: 0.5) {
            self.playerXLabel.center = self.xInitialCenter
            self.playerOLabel.center = self.oInitialCenter
            
            // 重置透明度
            self.playerXLabel.alpha = 1.0
            self.playerOLabel.alpha = 0.5
            
            // 重新启用交互
            self.playerXLabel.isUserInteractionEnabled = true
            self.playerOLabel.isUserInteractionEnabled = false
        }
        
        // 4. 再次启动 X 的开场动画
        startTurn(for: .x)
    }
    func startTurn(for player: Player) {
        // 1. 确定是谁的棋子
        let piece = (player == .x) ? playerXLabel : playerOLabel
        
        // 2. 设置为完全不透明
        piece?.alpha = 1.0
        
        // 3. 动画：先放大再缩小（像心跳一样跳动一下）
        // 这满足了作业中“吸引注意”的要求
        UIView.animate(withDuration: 0.5, animations: {
            piece?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }) { _ in
            UIView.animate(withDuration: 0.5) {
                piece?.transform = .identity // 恢复原始大小
            } completion: { _ in
                // 4. 动画结束后才允许玩家拖动
                piece?.isUserInteractionEnabled = true
            }
        }
    }
    func switchPlayer() {
        // 1. 切换逻辑：如果是 x 就变 o，反之亦然
        currentPlayer = (currentPlayer == .x) ? .o : .x
        
        // 2. 更新 UI 状态
        if currentPlayer == .x {
            // 激活 X，淡化 O
            startTurn(for: .x)
            playerOLabel.alpha = 0.5
            playerOLabel.isUserInteractionEnabled = false
        } else {
            // 激活 O，淡化 X
            startTurn(for: .o)
            playerXLabel.alpha = 0.5
            playerXLabel.isUserInteractionEnabled = false
        }
    }
}

