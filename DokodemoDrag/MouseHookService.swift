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
                self.element?.resize(delta: CGPoint(x: event.deltaX, y: event.deltaY), quadrant: self.quadrant)
            } else if event.modifierFlags.contains(.command) {
                self.element?.move(delta: CGPoint(x: event.deltaX, y: event.deltaY))
            }
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
