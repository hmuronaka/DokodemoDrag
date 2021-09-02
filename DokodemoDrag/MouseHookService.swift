//
//  MouseHookService.swift
//  DokodemoDrag
//
//  Created by Hiroaki Muronaka on 2021/08/21.
//  Copyright © 2021 Muronaka Hiroaki. All rights reserved.
//

import Cocoa

class MouseHookService {
    static let shared = MouseHookService()
    
    private var element: AccessibilityElement?
    private var eventMonitor: Any?
    
    /// 象限. マウスクリックした際に、クリックしたウィンドウの中央から見て
    //  第１〜第４象限のどこがクリックされたかを保持する（リサイズの仕方を調整するため）
    // quardrant: 四分儀(象限)
    private var quadrant: Int = 0
    
    // ダブルクリックを検出するためのタイマー
    private var timerForDoubleClick: Timer?
    
    private var isRunningTimerForDoubleClick: Bool {
        return timerForDoubleClick != nil
    }

    private init() {

    }
    
    public func start() {
        stop()
        
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .leftMouseDragged, .leftMouseUp]) { event in
            self.handleMouseEvent(event)
        }
    }
    
    public func stop() {
        guard let eventMonitor = eventMonitor else { return }
        NSEvent.removeMonitor(eventMonitor)
        
        self.eventMonitor = nil
        self.element = nil
    }

    private func handleMouseEvent(_ event: NSEvent) {
        guard !event.modifierFlags.intersection([.command, .shift]).isEmpty else {
            self.element = nil
            return
        }

        if event.type == .leftMouseDown {
            self.element = AccessibilityElement.windowUnderCursor()
            updateQuadrant( event )
        } else if event.type == .leftMouseUp {
            // double-clickを検出した.
            if isRunningTimerForDoubleClick {
                stopTimerForDoubleClick()
                // double-clickされたwindowをセンタリングする
                self.moveElementToCenterOnScreen(event)
                self.element = nil
                self.quadrant = 0
            // single-clickを検出
            } else {
                startTimerForDoubleClick()
            }
        } else if event.type == .leftMouseDragged {
            stopTimerForDoubleClick()
            if event.modifierFlags.contains([.command, .shift]){
                self.resizeElement(event)
            } else if event.modifierFlags.contains(.command) {
                self.moveElement(event)
            }
        }
    }
    
    private func startTimerForDoubleClick() {
        timerForDoubleClick?.invalidate()
        
        // double-click検出用タイマーを開始する
        timerForDoubleClick = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { t in
            self.timerForDoubleClick = nil
            self.element = nil
            self.quadrant = 0
        })
    }
    
    private func stopTimerForDoubleClick() {
        self.timerForDoubleClick?.invalidate()
        self.timerForDoubleClick = nil
    }
    
    /// mouseの移動量に基づいて要素をresizeする
    /// - Parameter event: mouseイベント
    private func resizeElement(_ event: NSEvent) {
        guard let elem = self.element, let size = elem.getSize(), let position = elem.getPosition() else {
            return
        }
        var newSize: CGSize = size
        var newPosition: CGPoint = position
        // quardrant: 象限
        switch quadrant {
        case 1:
            // Window右上境界をドラッグするresizeと同等の動作。
            newSize = CGSize(width: size.width + event.deltaX, height: size.height - event.deltaY)
            newPosition = CGPoint(x: position.x, y: position.y + event.deltaY)
        case 2:
            // Window左上境界をドラッグするresizeと同等の動作。
            newSize = CGSize(width: size.width - event.deltaX, height: size.height - event.deltaY)
            newPosition = CGPoint(x: position.x + event.deltaX, y: position.y + event.deltaY)
        case 3:
            // Window左下境界をドラッグするresizeと同等の動作。
            newSize = CGSize(width: size.width - event.deltaX, height: size.height + event.deltaY)
            newPosition = CGPoint(x: position.x + event.deltaX, y: position.y)
        case 4:
            // Window右下境界をドラッグするresizeと同等の動作。
            fallthrough
        default:
            newSize =  CGSize(width: size.width + event.deltaX, height: size.height + event.deltaY)
        }
        elem.set(size: newSize)
        elem.set(position: newPosition)
    }
    
    
    /// mouseの移動量に基づいて要素を移動する。
    /// - Parameter event: mouseイベント
    private func moveElement(_ event: NSEvent) {
        guard let elem = self.element, let pos = elem.getPosition() else {
            return
        }
        elem.set(position: .init(x: pos.x + event.deltaX, y: pos.y + event.deltaY))
    }

    
    /// eventのマウスカーソルの位置のWindowをセンタリングする
    /// - Parameter event: マウスイベント
    private func moveElementToCenterOnScreen(_ event: NSEvent) {
        // 画面サイズを取得する
        guard let frame = NSScreen.main?.frame, let elem = self.element, let elemSize = elem.getSize() else {
            return
        }
        let center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        let leftTop = CGPoint(x: center.x - elemSize.width * 0.5, y: center.y - elemSize.height * 0.5)
        elem.set(position: leftTop)
        elem.bringToFront()
    }

    /// mouse eventからクリックされたウィンドウ上の第１象限〜第４象限のどこがクリックされたかを
    /// 記録する
    /// - Parameter event: mouse event
    private func updateQuadrant(_ event: NSEvent) {
        guard let size = self.element?.getSize(), let position = self.element?.getPosition() else {
            return
        }
        let center = CGPoint(x: position.x + size.width * 0.5, y: position.y + size.height * 0.5)
        let location = event.locationInWindow
        
        let x = location.x >= center.x
        let y = location.y >= center.y
        quadrant = x ?
            (y ? 1 : 4) :
            (y ? 2 : 3)
        NSLog("quadrant: \(quadrant)")
    }
    

}
