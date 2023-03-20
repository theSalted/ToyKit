//
//  EmojiNodeSpawnerComponet.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/23/23.
//

import GameplayKit
import SpriteKit

/// Spwan Emoji nodes on scene
class EmojiNodeSpawnerComponet : GKComponent, PackageComponent {
    
    // MARK: Properties
    var node : SKNode
    
    var dependentComponents: [GKComponent.Type]
    
    // MARK: Init
    init(node: SKNode) {
        self.node = node
        
        dependentComponents = [PointerEventComponent.self]
        
        super.init()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    
    override func didAddToEntity() {
        
        // Create random emoji node when pointer event is triggered
        // - TODO: maybe add entity rather than nodes?
        coComponent(ofType: PointerEventComponent.self)?.subscribe(type: .began, actions: { [self] locations in
            let emojiNode = createRandomEmojiNode(position: locations)
            node.addChild(emojiNode)
        })
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
    
}
