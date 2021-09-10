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
    
    private var recognizers = [Recognizer]()
    
    /// 象限. マウスクリックした際に、クリックしたウィンドウの中央から見て
    //  第１〜第４象限のどこがクリックされたかを保持する（リサイズの仕方を調整するため）
    // quardrant: 四分儀(象限)
    private var quadrant: Int = 0
    
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
    
    public func addRecognizer(_ recognizer: Recognizer) {
        self.recognizers.append(recognizer)
    }

    private func handleMouseEvent(_ event: NSEvent) {
        guard !event.modifierFlags.intersection([.command, .shift]).isEmpty else {
            self.element = nil
            return
        }
        
        for recognizer in recognizers {
            recognizer.handleMouseEvent(event)
        }

        if event.type == .leftMouseDown {
            self.element = AccessibilityElement.windowUnderCursor()
            updateQuadrant( event )
        } else if event.type == .leftMouseDragged {
            if event.modifierFlags.contains([.command, .shift]){
                self.resizeElement(event)
            } else if event.modifierFlags.contains(.command) {
                self.element?.move(delta: CGPoint(x: event.deltaX, y: event.deltaY))
            }
        }
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
        // windowは最小sizeがある場合があるので、resizeしてwidthかheightが変わらなかった場合、
        // window位置を移動しないようにする。
        if let resizedSize = elem.getSize() {
            if resizedSize.width == size.width {
                newPosition.x = position.x
            }
            if resizedSize.height == size.height {
                newPosition.y = position.y
            }
            elem.set(position: newPosition)
        }
    }
    



    /// mouse eventからクリックされたウィンドウ上の第１象限〜第４象限のどこがクリックされたかを
    /// 記録する
    /// - Parameter event: mouse event
    private func updateQuadrant(_ event: NSEvent) {
        // elemRect: 左上が(0, 0)の座標系
        guard let rect = self.element?.rectOfElement(), let screen = NSScreen.main else {
            return
        }
        // 左下が(0, 0)の座標系
        // NOTE: event.locationInWindow == NSEvent.mouseLocation と言う結果になる
        let location = event.locationInWindow
        // 座標系の変換方法を調べきれていないため、screenの高さを用いて、マウスのy座標を左上が(0,0)になるようにしている。
        self.quadrant = rect.quardrant(point: CGPoint(x: location.x, y: screen.frame.height - location.y))
    }
    

}
