import Foundation

enum Player {
    case x, o
}

class Grid {
    // 使用字典或数组记录位置，key 为 0-8 的索引
    private var cells: [Int: Player] = [:]
    
    func occupies(at index: Int, with player: Player) {
        cells[index] = player
    }
    
    func isSquareEmpty(at index: Int) -> Bool {
        return cells[index] == nil
    }
    
    func checkWinner() -> Player? {
        let winPatterns = [
            [0,1,2], [3,4,5], [6,7,8], // 横
            [0,3,6], [1,4,7], [2,5,8], // 纵
            [0,4,8], [2,4,6]           // 斜
        ]
        
        for pattern in winPatterns {
            if let p = cells[pattern[0]], p == cells[pattern[1]], p == cells[pattern[2]] {
                return p
            }
        }
        return nil
    }
    
    func isTie() -> Bool {
        return cells.count == 9 && checkWinner() == nil
    }
    
    func reset() {
        cells.removeAll()
    }
}
