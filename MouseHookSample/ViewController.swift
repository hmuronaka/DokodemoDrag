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
        // Do any additional setup after loading the view.
    }
    
    private var element: AccessibilityElement?
    
    private func handleMouseEvent(_ event: NSEvent) {
        guard !event.modifierFlags.intersection([.command, .shift]).isEmpty else {
            self.element = nil
            return
        }
        
        if event.type == .leftMouseDown {
            self.element = AccessibilityElement.windowUnderCursor()
        } else if event.type == .leftMouseUp {
            self.element = nil
        } else if let elem = self.element,  event.type == .leftMouseDragged {
            if event.modifierFlags.contains([.command, .shift]), let size = elem.getSize() {
                elem.set(size: .init(width: size.width + event.deltaX, height: size.height + event.deltaY))
            } else if event.modifierFlags.contains(.command), let pos = elem.getPosition() {
                elem.set(position: .init(x: pos.x + event.deltaX, y: pos.y + event.deltaY))
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

