//
//  FrictionSceneComponentModel.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/27/23.
//

import GameplayKit
import SpriteKit
import SwiftUI

@MainActor
final class FrictionSceneComponentModel: GKComponent, ObservableObject {
    
    @Published var friction : Double = 0.2
    
    /// A list of co-component types that this component depends on.
    ///
    /// - NOTE: The component should not raise an application-halting error or exception if a dependency is missing, because components may be added to or removed from an entity during runtime to dynamically modify the entity's behavior. In the absence of a dependency, a component should fail gracefully and simply skip a part or all of its functionality, optionally logging a warning.
    ///  Credit: ShinryakuTako@invadingoctopus.io
    var prerequisiteComponets: [GKComponent.Type]? {
        [PhysicsBodySceneComponentModel.self]
    }
    
    /// Check if the compponet is attached to an entity and any of the components is missing in `prerequisiteComponets`.
    ///
    /// - RETURNS: `true` if there are no missing dependencies or no `prerequisiteComponets
    ///
    ///  - This function should become either an extension of GKComponent, a helper function of a manager class / custom open class
    ///
    ///  Credit - ShinryakuTako@invadingoctopus.io
    @discardableResult
    func checkPrerequisiteAndEnvironmentCompliance() -> Bool {
        var isMissingDependencies: Bool = false
        
        // Return false if there is no `prerequisiteComponets`
        if self.prerequisiteComponets == nil {
            return false
        }
        
        guard let entity = self.entity else {
            // return true if component is not attached to an entity
            // TODO: A proper warning and debug system
            print("Warning: Component is not attached to an entity")
            return true
        }
        
        self.prerequisiteComponets?.forEach { requiredComponentType in
            let matchedComponent = self.coComponent(ofType: requiredComponentType)
            
            if matchedComponent?.componentType != requiredComponentType {
                print("Warning: \(entity)  is missing a \(requiredComponentType) (or a RelayComponent linked to it) which is required by \(self)")
                
                isMissingDependencies = true
            }
        }
        
        return !isMissingDependencies
    }
    
    /// Update friction setting if `PhysicsBodySceneComponentModel` is installed
    func updateFriction() {
        if checkPrerequisiteAndEnvironmentCompliance() {
            coComponent(ofType: PhysicsBodySceneComponentModel.self)?.physicsBody?.friction = friction
        }
    }
    
    func validateFriction(friction : CGFloat) -> Bool {
        let frictionRange = 0.0...1.0
        return frictionRange.contains(friction)
    }
    /// Set friction setting if `PhysicsBodySceneComponentModel` is installed
    func setFriction(friction : CGFloat) {
        self.friction = friction
        updateFriction()
    }
    
    override func didAddToEntity() {
        updateFriction()
    }
    
    override func willRemoveFromEntity() {
        setFriction(friction: 0.0)
    }
    
    @ViewBuilder
    func inspectorView() -> some View {
        FrictionInspectorView(component: self)
    }
}
