# TicTacToe

A classic Tic Tac Toe game developed in Swift and UIKit for iOS.

## Features

- Classic 3x3 grid Tic Tac Toe gameplay
- Custom GridView for drawing the game board
- Drag and drop interaction for placing pieces
- Real-time visual feedback:
  - Player turn highlight animation
  - Green highlight for valid positions
  - Red highlight for occupied positions
  - Forbidden notification for occupied cells
  - Victory/Draw popup animation
  - Smooth piece snap and bounce animations
- Automatic win/draw detection
- Game reset functionality

## Tech Stack

- Swift
- UIKit
- Storyboard
- Custom view drawing
- Gesture recognition (Pan gesture)
- Auto Layout and fixed frames

## Game Rules

1. X goes first, players alternate turns
2. Drag X or O into the 3x3 grid
3. First player to get three in a row (horizontal, vertical, or diagonal) wins
4. If all cells are filled with no winner, it's a draw

## File Structure

- `ViewController.swift` - Main game logic and UI controller
- `Grid.swift` - Game data model and win/draw detection
- `GridView.swift` - Custom grid drawing view
- `InfoView.swift` - Game result popup view
- `Main.storyboard` - UI layout and connections

## Installation & Setup

1. Clone the repository
2. Open `TicTacToe.xcodeproj` in Xcode
3. Select a simulator or device
4. Press Cmd+R to run

## System Requirements

- Xcode 14.0 or later
- iOS 13.0 or later

## How to Play

### Starting the Game

1. Launch the app on an iOS device or simulator
2. You'll see the game board (3x3 grid) in the center
3. Two player labels appear at the bottom: "X" (pink) and "O" (blue)

### Gameplay

1. **X player's turn** - The X label will be bright, O will be dimmed
2. **Drag X piece** - Touch and drag the X label towards the game board
3. **Visual feedback** - As you drag:
   - If hovering over an empty cell: the cell highlights in GREEN
   - If hovering over an occupied cell: the cell highlights in RED
4. **Place the piece** - Release your finger on a green-highlighted cell
   - A copy of X appears in that cell
   - The original X label returns to the bottom for reuse
5. **Switch turns** - O player's turn (same process as X)

### Win/Draw Detection

- **Player Wins**: When any player gets 3 pieces in a row, a popup appears: "X Wins!" or "O Wins!"
- **Draw**: If all cells are filled with no winner, a popup appears: "Draw!"
- **Reset Game**: Click "OK" button in the popup to start a new game

### Error Handling

- **Occupied Position**: If you try to place on an already occupied cell:
  - The cell highlights in RED
  - A forbidden message appears: "Position Occupied"
  - Your piece bounces back to the starting position
  - You can try again

## Game Tips

- The center cell (middle position) is strategically important
- Try to create multiple threats to force your opponent into a defensive position
- The corners and edges have different strategic values
- Classic strategy: take center or corner on first move

## Known Limitations

- Game is limited to 2 local players (no AI)
- No game history or scoring system
- Portrait orientation only

## Future Enhancements

- Add AI opponent with difficulty levels
- Implement game statistics and win tracking
- Add sound effects and haptic feedback
- Support device rotation
- Multiplayer online play
- Swift 5.0+

## 作者

Judy Zhu

## 日期

2026年2月
