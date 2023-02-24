//
//  PrimaryPointerEventComponent.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/23/23.
//

import GameplayKit

// TODO: re-implement OctupusKit's control delegate
class PrimaryPointerEventComponent : GKComponent {
    public enum PrimaryEventState {
        /// A `pointerBegan` event, when a touch or click has occurred.
        case began
        
        /// A `pointerMoved` event, when a touch has moved or the mouse pointer has been dragged.
        case moved
        
        /// A `pointerEnded` event, when a touch or mouse button has been lifted.
        case ended
    }
    
    var primaryPointerState : PrimaryEventState? = nil
}
