//
//  ComponentJunk.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/23/23.
//

/*

        
 class Castle: GKEntity {

   init(imageName: String) {
     super.init()

     // 2
     let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
     addComponent(spriteComponent)
   }
   
   required init?(coder aDecoder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
   }
 }
 
 private final class PointerEventComponent : GKComponent {
     lazy var scene : SKScene? = {
         entity?.scene
     }()
     
     
 }

 class EntityManager {

   // 1
   var entities = Set<GKEntity>()
   let scene: SKScene

   // 2
   init(scene: SKScene) {
     self.scene = scene
   }

   // 3
   func add(_ entity: GKEntity) {
     entities.insert(entity)

     if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
       scene.addChild(spriteNode)
     }
   }

   // 4
   func remove(_ entity: GKEntity) {
     if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
       spriteNode.removeFromParent()
     }

     entities.remove(entity)
   }
 }
 
 class SpriteComponent: GKComponent {

   // 3
   let node: SKSpriteNode

   // 4
   init(texture: SKTexture) {
     node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
     super.init()
   }
   
   // 5
   required init?(coder aDecoder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
   }
 }

 class DynamicPhysicsBodyComponent: GKComponent {
     let dynamicPhysicsBody = SKShapeNode()
     
     var scene : SKScene {
         guard let scene = entity?.scene else {
             fatalError("This entity don't have node")
         }
         return scene
     }
     
     override init() {
         super.init()
     }
     
     override func didAddToEntity() {
         
     }
     
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
 }
 
 class Test : GKComponent {
     
     @Published var testVar = "test"
     
     var TestInspectView: some View {
         Text("")
     }
     
 }


*/
