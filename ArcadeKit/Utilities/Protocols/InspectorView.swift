//
//  ComponentModel.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/28/23.
//

import SwiftUI
import GameplayKit

/// A protocol for an object with inspectorView attached to it
@MainActor
protocol InspectorView {
    associatedtype T: View
    
    var isRemoveable : Bool { get set }
    
    var isPriority : Bool { get set }
    
    /// Return view for inspector
    /// - NOTE: `nonisolated` to suppress compiler warning, method can't directly access actor-isolated properties
    nonisolated func inspectorView() -> T
}

