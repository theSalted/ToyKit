//
//  PrimaryPointerEventComponent.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/23/23.
//

import GameplayKit

// TODO: re-implement OctupusKit's control delegate

/// A device-agnostic component that provides abstraction for the entity's `TouchEventComponent` on iOS or `MouseEventComponent` on macOS, for relaying player input from pointer-like sources, such as touch or mouse, to other components which depend on player input.
///
/// This is component simplifies `TouchEventComponent` on iOS and `MouseEventComponent`  on macOS
/// Only stores the location of a single pointer; does not differentiate between number of pointers (fingers), type of mouse buttons (left/right), or modifier keys (Shift/Control/etc.)
/// This component also only reveal event's location
///
/// **Dependencies:** `TouchEventComponent` on iOS, `MouseEventComponent` on macOS.
class PointerEventComponent : GKComponent, PackageComponent {
    
    var dependentComponents: [GKComponent.Type]
    
    var node : SKNode
    
    enum PointerEventType {
        /// A `pointerBegan` event, when a touch or click has occurred.
        case began
        
        /// A `pointerMoved` event, when a touch has moved or the mouse pointer has been dragged.
        case moved
        
        /// A `pointerEnded` event, when a touch or mouse button has been lifted.
        case ended
    }
    
    lazy private var pointerBeganCallbacks = [(CGPoint) -> Void]()
    lazy private var pointerMovedCallbacks = [(CGPoint) -> Void]()
    lazy private var pointerEndedCallbacks = [(CGPoint) -> Void]()
    
    /// A list of co-component types that this component depends on. Dependent component will be automatically attached when this component is attached
    ///
    /// - NOTE: The component should not raise an application-halting error or exception if a dependency is missing, because components may be added to or removed from an entity during runtime to dynamically modify the entity's behavior. In the absence of a dependency, a component should fail gracefully and simply skip a part or all of its functionality, optionally logging a warning.
    
    
    init(node: SKNode) {
        self.node = node
        
        // declare dependecy
        #if canImport(AppKit)
        dependentComponents = [MouseEventComponent.self]
        #elseif canImport(UIKit)
        dependentComponents = [TouchEventComponent.self]
        #endif
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func attachToDependent() {
        #if canImport(AppKit)
        coComponent(ofType: MouseEventComponent.self)?.subscribe(type: .mouseDown, actions: { [self] event in
            let location = event.location(in: node)
            
            for pointerBeganCallback in pointerBeganCallbacks {
                pointerBeganCallback(location)
            }
        })

        coComponent(ofType: MouseEventComponent.self)?.subscribe(type: .mouseUp, actions: { [self] event in
            let location = event.location(in: node)
            
            for pointerEndedCallback in pointerEndedCallbacks {
                pointerEndedCallback(location)
            }
        })

        coComponent(ofType: MouseEventComponent.self)?.subscribe(type: .mouseDown, actions: { [self] event in
            let location = event.location(in: node)
            
            for pointerMovedCallback in pointerMovedCallbacks {
                pointerMovedCallback(location)
            }
        })

        #elseif canImport(UIKit)
        coComponent(ofType: TouchEventComponent.self)?.subscribe(type: .touchesBegan, actions: { [self] touches, event in
            guard let touch = touches.first else { return }
            let location = touch.location(in: node)
            
            for pointerBeganCallback in pointerBeganCallbacks {
                pointerBeganCallback(location)
            }
        })
        
        coComponent(ofType: TouchEventComponent.self)?.subscribe(type: .touchesEnded, actions: { [self] touches, event in
            guard let touch = touches.first else { return }
            let location = touch.location(in: node)
            
            for pointerEndedCallback in pointerEndedCallbacks {
                pointerEndedCallback(location)
            }
        })
        
        coComponent(ofType: TouchEventComponent.self)?.subscribe(type: .touchesMoved, actions: { [self] touches, event in
            guard let touch = touches.first else { return }
            let location = touch.location(in: node)
            
            for pointerMovedCallback in pointerMovedCallbacks {
                pointerMovedCallback(location)
            }
        })
        
        #endif
        
    }
    
    override func didAddToEntity() {
        attachToDependent()
    }
    
    
    /// Will Iinform subscirbed closures that the user has triggered a new pointer event of designated type
    func subscribe(type: PointerEventType, actions: @escaping (CGPoint) -> Void) {
        switch type {
        case .began:
            pointerBeganCallbacks.append(actions)
        case .ended:
            pointerEndedCallbacks.append(actions)
        case .moved:
            pointerMovedCallbacks.append(actions)
        }
    }
}
