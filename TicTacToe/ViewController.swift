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
    
    // 插座 2：游戏角色的 Label
    @IBOutlet weak var playerXLabel: UILabel!
    @IBOutlet weak var playerOLabel: UILabel!
    
    // 插座 3：弹出的信息视图
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
        }
        
        // 2. 手指松开
        if sender.state == .ended {
            var didSnap = false
            
            // 遍历那 9 个格子看中了没
            for (index, zone) in dropZones.enumerated() {
                if piece.frame.intersects(zone.frame) && grid.isSquareEmpty(at: index) {
                    // 击中目标！吸附过去
                    UIView.animate(withDuration: 0.2) {
                        piece.center = zone.center
                    }
                    piece.isUserInteractionEnabled = false // 固定住，不能再动了
                    grid.occupies(at: index, with: currentPlayer) // 记录数据
                    didSnap = true
                    checkGameStatus() // 检查输赢
                    break
                }
            }
            
            // 3. 没投中，弹回原位
            if !didSnap {
                UIView.animate(withDuration: 0.3) {
                    piece.center = (self.currentPlayer == .x) ? self.xInitialCenter : self.oInitialCenter
                }
            }
        }
    }
    func checkGameStatus() {
        // 1. 检查是否有赢家
        if let winner = grid.checkWinner() {
            isGameOver = true
            let winnerName = (winner == .x) ? "X" : "O"
            showInfo(with: "恭喜！\(winnerName) 赢了！")
            
        }
        // 2. 如果没赢家，检查是否平局（格子满了）
        else if grid.isTie() {
            isGameOver = true
            showInfo(with: "握手言和，这是平局！")
            
        }
        // 3. 游戏继续，换下一个人
        else {
            switchPlayer()
        }
    }
    func showInfo(with message: String) {
        // 1. 设置文字（添加安全检查）
        infoView.messageLabel?.text = message
        
        // 2. 确保它在动画开始前处于屏幕上方
        infoView.center = CGPoint(x: view.center.x, y: -200)
        
        // 3. 掉落动画：使用弹簧效果 (usingSpringWithDamping) 更有趣
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.infoView.center = self.view.center // 移动到画面中心
        }, completion: nil)
    }
    func resetGame() {
        // 1. 模型清空
        grid.reset()
        isGameOver = false
        currentPlayer = .x
        
        // 2. 把 X 和 O 标签移回它们最初的位置
        UIView.animate(withDuration: 0.5) {
            self.playerXLabel.center = self.xInitialCenter
            self.playerOLabel.center = self.oInitialCenter
            
            // 重置透明度
            self.playerXLabel.alpha = 1.0
            self.playerOLabel.alpha = 0.5
            
            // 这里可以遍历并删除你在格子里生成的棋子副本（如果有的话）
            // 或者简单的把 X 和 O 设为可交互
            self.playerXLabel.isUserInteractionEnabled = true
            self.playerOLabel.isUserInteractionEnabled = false
        }
        
        // 3. 再次启动 X 的开场动画
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
