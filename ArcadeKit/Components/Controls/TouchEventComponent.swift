//
//  TouchEventComponent.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/28/23.
//

import GameplayKit

#if canImport(UIKit)
/// Attach this component to subscribe to scene's touch events
@available(iOS 12, *)
final class TouchEventComponent : GKComponent {
    enum TouchEventType {
        case touchesBegan, touchesEnded, touchesMoved, touchesCancelled
    }
    
    lazy private var touchesBeganCallbacks = [(Set<UITouch>, UIEvent?) -> Void]()
    lazy private var touchesEndedCallbacks = [(Set<UITouch>, UIEvent?) -> Void]()
    lazy private var touchesMovedCallbacks = [(Set<UITouch>, UIEvent?) -> Void]()
    lazy private var touchesCancelledCallbacks = [(Set<UITouch>, UIEvent?) -> Void]()
    
    /// Inform each item in callback list that useser has triggered a touch event of designated type
    /// - Warning: This is a utility function exclusively for system defined `SKScene` object to update subscribers and should not be called by user
    func updateEvent(touches: Set<UITouch>, event: UIEvent?, type: TouchEventType) {
        switch type {
        case .touchesBegan:
            for touchesBeganCallback in touchesBeganCallbacks {
                touchesBeganCallback(touches, event)
            }
        case .touchesEnded:
            for touchesEndedCallback in touchesEndedCallbacks {
                touchesEndedCallback(touches, event)
            }
        case .touchesMoved:
            for touchesMovedCallback in touchesMovedCallbacks {
                touchesMovedCallback(touches, event)
            }
        case .touchesCancelled:
            for touchesCancelledCallback in touchesCancelledCallbacks {
                touchesCancelledCallback(touches, event)
            }
        }
    }
    
    /// Reset all callbacks functions
    func clearCallbacks() {
        touchesBeganCallbacks = [(Set<UITouch>, UIEvent?) -> Void]()
        touchesEndedCallbacks = [(Set<UITouch>, UIEvent?) -> Void]()
        touchesMovedCallbacks = [(Set<UITouch>, UIEvent?) -> Void]()
        touchesCancelledCallbacks = [(Set<UITouch>, UIEvent?) -> Void]()
    }
    
    
    /// Will Iinform subscirbed closures that the user has triggered a new mouse event of designated type
    func subscribe(type: TouchEventType, actions: @escaping (Set<UITouch>, UIEvent?) -> Void) {
        switch type {
        case .touchesBegan:
            touchesBeganCallbacks.append(actions)
        case .touchesEnded:
            touchesEndedCallbacks.append(actions)
        case .touchesMoved:
            touchesMovedCallbacks.append(actions)
        case .touchesCancelled:
            touchesCancelledCallbacks.append(actions)
        }
    }
    
    override func willRemoveFromEntity() {
        clearCallbacks()
    }
}
#endif
