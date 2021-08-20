//
//  ViewController.swift
//  MouseHookSample
//
//  Created by MuronakaHiroaki on 2021/08/19.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let result = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .leftMouseDragged, .leftMouseUp]) { event in
            self.handleMouseEvent(event)
        }
        NSLog("result: \(result)")
        // Do any additional setup after loading the view.
    }
    
    private var element: AccessibilityElement?
    
    private func handleMouseEvent(_ event: NSEvent) {
        let keys = [
            "leftMouseDown",
            "leftMouseUp",
            "leftMouseDragged",
            "rightMouseDown",
            "rightMouseUp",
            "rightMouseDragged",
        ]
        let tbl: [String: NSEvent.EventType] = [
            "leftMouseDown": .leftMouseDown,
            "leftMouseUp": .leftMouseUp,
            "leftMouseDragged": .leftMouseDragged,
            "rightMouseDown": .rightMouseDown,
            "rightMouseUp": .rightMouseUp,
            "rightMouseDragged": .rightMouseDragged,
        ]
        var str = ""
        for key in keys {
            let value = tbl[key]!
            str += "\n[\(key): \( (event.type.rawValue & value.rawValue) != 0)]"
        }
//        NSLog(str)
//        NSLog("modifier: \(event.modifierFlags.contains(.command))")
//        NSLog("window: \(event.window)")
        
        guard event.modifierFlags.contains(.command) else {
            self.element = nil
            return
        }
        
        if event.type == .leftMouseDown {
            self.element = AccessibilityElement.windowUnderCursor()
            NSLog("Down: element:\(self.element)")
        } else if event.type == .leftMouseUp {
            self.element = nil
            NSLog("Up: element:\(self.element)")
        } else if let elem = self.element,  event.type == .leftMouseDragged, let pos = elem.getPosition() {
            NSLog("pos: \(pos)")
            elem.set(position: .init(x: pos.x + event.deltaX, y: pos.y + event.deltaY))
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

