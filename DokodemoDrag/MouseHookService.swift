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
        } else if event.type == .leftMouseUp {
            // double-clickを検出した.
            if isRunningTimerForDoubleClick {
                stopTimerForDoubleClick()
                // double-clickされたwindowをセンタリングする
                self.moveElementToCenterOnScreen(event)
                self.element = nil
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
        })
    }
    
    private func stopTimerForDoubleClick() {
        self.timerForDoubleClick?.invalidate()
        self.timerForDoubleClick = nil
    }
    
    /// mouseの移動量に基づいて要素をresizeする
    /// - Parameter event: mouseイベント
    private func resizeElement(_ event: NSEvent) {
        guard let elem = self.element, let size = elem.getSize() else {
            return
        }
        elem.set(size: .init(width: size.width + event.deltaX, height: size.height + event.deltaY))
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

}
