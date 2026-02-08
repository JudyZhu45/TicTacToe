# TicTacToe

一个用 Swift 和 UIKit 开发的 iOS 井字棋游戏。

## 功能特点

- 🎮 九宫格井字棋游戏
- 🎨 自定义 GridView 绘制九宫格线条
- ✨ 拖拽交互操作
- 🎭 动画效果：
  - 开场动画提示当前玩家
  - 胜利/平局弹窗动画
  - 棋子吸附和弹回动画
- 🏆 自动判断胜负和平局
- 🔄 游戏重置功能

## 技术栈

- Swift
- UIKit
- Storyboard
- 自定义视图绘制
- 手势识别

## 游戏规则

1. X 玩家先手，每次轮流落子
2. 将 X 或 O 拖拽到九宫格中
3. 三子连成一线（横/竖/斜）即为胜利
4. 格子占满无人获胜则为平局

## 文件结构

- `ViewController.swift` - 主游戏逻辑控制器
- `Grid.swift` - 游戏数据模型和胜负判断
- `GridView.swift` - 自定义九宫格绘制视图
- `InfoView.swift` - 游戏结果弹窗视图
- `Main.storyboard` - 界面布局

## 安装运行

1. 克隆仓库
2. 使用 Xcode 打开 `TicTacToe.xcodeproj`
3. 选择模拟器或真机
4. 点击运行按钮 (⌘R)

## 开发环境

- Xcode 14.0+
- iOS 13.0+
- Swift 5.0+

## 作者

Judy Zhu

## 日期

2026年2月
