//
//  EmojiNodeSpawnerComponet.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/23/23.
//

import GameplayKit
import SpriteKit

class EmojiNodeSpawnerComponet : GKComponent {
    
    /// A list of co-component types that this component depends on.
    ///
    /// - NOTE: The component should not raise an application-halting error or exception if a dependency is missing, because components may be added to or removed from an entity during runtime to dynamically modify the entity's behavior. In the absence of a dependency, a component should fail gracefully and simply skip a part or all of its functionality, optionally logging a warning.
    ///  Credit: ShinryakuTako@invadingoctopus.io
    var prerequisiteComponets: [GKComponent.Type]? {
        // TODO: add cotntorl component once control system became ECS complied
        //[PrimaryPointerEventComponent.self]
        nil
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
    
    /// Create an randon emoji  as SKLabelNode and offset it
    func createRandomEmojiNode(position: CGPoint) -> SKLabelNode {
        let emojis = "👾🕹🚀🎮📱⌚️💿📀🧲🧿🎲🍏🥎🍄🧠👁💩😈👿👻💀👽🤖🎃👊🏻💧☁️🚗💣🧸🧩🎨🎸⚽️🎱🍖🍑🍆🍩🍌⭐️🌈🌸🌺🌼🐹🦊🐼🐱🐶❤️🧡💛💚💙💜💔🔶🔷♦️"
        let randomEmoji = String(emojis.randomElement()!)
        let emojiNode = SKLabelNode(text: randomEmoji)
        emojiNode.fontSize = 64
        emojiNode.position = position
        emojiNode.zPosition = -10
        
        emojiNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(widthAndHeight: 50), center: CGPoint(x: 0, y: 20))
        
        let randomAdjustment = CGVector(dx: CGFloat(Int.random(in: -40...40)),
                                        dy: CGFloat(Int.random(in: -10...25)))
        
        let randomForce = CGVector(dx: randomAdjustment.dx/3,
                                   dy: CGFloat(Int.random(in: 15...25)))
        emojiNode.run(
            .sequence([
                .applyImpulse(randomForce, duration: 0.1),
                .wait(forDuration: 10.0),
                .fadeOut(withDuration: 0.5),
                .removeFromParent()
            ])
        )
        return emojiNode
    }
    
    override func didAddToEntity() {
        checkPrerequisiteAndEnvironmentCompliance()
        guard self.entity != nil else {
            fatalError("Component fatal non-compliacne: entity not set")
        }
    }
    
}
