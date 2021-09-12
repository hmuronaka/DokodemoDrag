//
//  DoubleClickRecognizer.swift
//  DokodemoDrag
//
//  Created by MuronakaHiroaki on 2021/09/10.
//

import Cocoa


/// ダブルクリック専用のrecognizer
class DoubleClickRecognizer: Recognizer {
    
    /// ダブルクリック検出時のcallback
    private var action: ( (_:NSEvent) -> () )?
    
    // ダブルクリックを検出するためのタイマー
    private var timerForDoubleClick: Timer?
    
    private var isRunningTimerForDoubleClick: Bool {
        return timerForDoubleClick != nil
    }

    func onAction(_ action: ((_:NSEvent) -> ())?) -> Self {
        self.action = action
        return self
    }

    func handleMouseEvent(_ event: NSEvent) {
        if event.type == .leftMouseUp {
            // double-clickを検出した.
            if isRunningTimerForDoubleClick {
                stopTimerForDoubleClick()
                self.action?(event)
            // single-clickを検出
            } else {
                startTimerForDoubleClick()
            }
        } else if event.type == .leftMouseDragged {
            stopTimerForDoubleClick()
        }
    }
    
    private func startTimerForDoubleClick() {
        timerForDoubleClick?.invalidate()
        
        // double-click検出用タイマーを開始する
        timerForDoubleClick = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { t in
            self.timerForDoubleClick = nil
        })
    }
    
    private func stopTimerForDoubleClick() {
        self.timerForDoubleClick?.invalidate()
        self.timerForDoubleClick = nil
    }
}
