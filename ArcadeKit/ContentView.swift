//
//  ContentView.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/16/23.
//

import SwiftUI
import OctopusKit
import SpriteKit
import GameController

enum PhysicsBodyType : String {
    case none = "None"
    case dynamicPhysicsBody = "Dynamic"
    case staticPhysicsBody = "Static"
}

final class GameScene : SKScene {
    
    var dynamicPhysicsBody = SKShapeNode()
    var physicsBodyType : PhysicsBodyType = .dynamicPhysicsBody
    
    private var isOngoingDPBReset = false
    
    override func didMove(to view: SKView) {
        //initDynamicPhysicsBody()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        if physicsBodyType == .dynamicPhysicsBody {
            updateDynamicPhysicsBodyScale()
        }
        
        if physicsBodyType == .staticPhysicsBody {
            physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        }
    }
    
    #if canImport(UIKit)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        primaryInputDown(location: location)
    }
    #elseif canImport(AppKit)
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        primaryInputDown(location: location)
    }
    #endif
    
    func createDynamicPhysicsBody() -> SKShapeNode {
        let sceneFrame = frame
        dynamicPhysicsBody = SKShapeNode(rect: sceneFrame)
        #if canImport(UIKit)
        dynamicPhysicsBody.strokeColor = Color(.blue)
        #elseif canImport(AppKit)
        dynamicPhysicsBody.strokeColor = NSColor(.blue)
        #endif
        dynamicPhysicsBody.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        return dynamicPhysicsBody
    }
    
    func updateDynamicPhysicsBodyScale() {
        if(!isOngoingDPBReset) {
            dynamicPhysicsBody.removeAllActions()
            var scaleFactorX = CGFloat()
            var scaleFactorY = CGFloat()
            
            var durationX = TimeInterval()
            var durationY = TimeInterval()
            
            scaleFactorX = frame.width / (dynamicPhysicsBody.frame.width / dynamicPhysicsBody.xScale)
            scaleFactorY = frame.height / (dynamicPhysicsBody.frame.height / dynamicPhysicsBody.yScale)
            
            if scaleFactorX > 1 {
                durationX = 0
            } else {
                durationX = (scaleFactorX/1) * 1
                if durationX < 0.2 {
                    durationX = 0.2
                }
            }
            
            if scaleFactorY > 1 {
                durationY = 0
            } else {
                durationY = (scaleFactorY/1) * 1
                if durationY < 0.2 {
                    durationY = 0.2
                }
            }
            
            let scaleX = SKAction.scaleX(to: scaleFactorX, duration: durationX)
            let scaleY = SKAction.scaleY(to: scaleFactorY, duration: durationY)
            let scale = SKAction.group([scaleX, scaleY])
            let reset = SKAction.run {
                self.resetDynamicPhysicsBody()
            }
            let sequence = SKAction.sequence([scale, reset])
            
            dynamicPhysicsBody.run(sequence)
        }
        
    }
    
    func resetDynamicPhysicsBody() {
        let dPLineWidth = dynamicPhysicsBody.lineWidth
        dynamicPhysicsBody.removeFromParent()
        dynamicPhysicsBody = createDynamicPhysicsBody()
        addChild(dynamicPhysicsBody)
        dynamicPhysicsBody.lineWidth = dPLineWidth
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func primaryInputDown(location: CGPoint)
    {
        addChild(createRandomEmojiNode(position: location))
    }
    
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

final class SceneSettings : ObservableObject {
    
    @Published var scene = GameScene()
    
    @Published var sceneSizeX : Double = 1000
    @Published var sceneSizeY : Double = 1000
    
    @Published var viewSizeX : Double = 1000
    @Published var viewSizeY : Double = 1000
    
    @Published var anchorPointX = 0.5
    @Published var anchorPointY = 0.0
    
    @Published var isDyniamicSceneSize = true
    @Published var isDynamicPhysicsBodyRendered = false
    
    @Published var selectedScaleMode : SKSceneScaleMode = .resizeFill
    @Published var scaleModes : [SKSceneScaleMode] = [.resizeFill, .aspectFit, .aspectFill, .fill]
    
    @Published var selectedPhysicsBodyType : PhysicsBodyType = .staticPhysicsBody
    let physicsBodyType : [PhysicsBodyType] = [.dynamicPhysicsBody, .staticPhysicsBody, .none]
    
    @Published var isPaused = false
    
    var dynamicRenderBodyLineWidth: CGFloat {
        return scene.dynamicPhysicsBody.lineWidth
    }
    
    func initGameScene() {
        updateSceenSizeSetting()
        updateSKColorScheme()
        updateAnchorPoint()
        updatePhysicsBodySetting()
    }
    
    func updateSKColorScheme() {
        #if canImport(AppKit)
        scene.backgroundColor = NSColor.windowBackgroundColor
        #endif
    }
    
    func updatePause() {
        scene.isPaused = isPaused
    }
    
    @discardableResult func updateDynamicPhysicsBodyRender() -> Bool {
        if isDynamicPhysicsBodyRendered {
            scene.dynamicPhysicsBody.lineWidth = 3
            return true
        } else {
            scene.dynamicPhysicsBody.lineWidth = 0
            return false
        }
    }
    
    func updateSceenSizeSetting() {
        
        switch selectedScaleMode {
        case.resizeFill:
            isDyniamicSceneSize = true
        default:
            isDyniamicSceneSize = false
        }
        
        scene.scaleMode = selectedScaleMode
        
        if isDyniamicSceneSize {
            sceneSizeX = viewSizeX
            sceneSizeY = viewSizeY
        }
        
        scene.size = CGSize(width: sceneSizeX, height: sceneSizeY)
    }
    
    func updatePhysicsBodySetting() {
        scene.physicsBodyType = selectedPhysicsBodyType
        if selectedPhysicsBodyType == .dynamicPhysicsBody {
            initDynamicPhysicsBody()
        } else {
            scene.dynamicPhysicsBody.removeFromParent()
        }
        
        if selectedPhysicsBodyType == .staticPhysicsBody {
            initPhysicsBody()
        } else {
            scene.physicsBody = nil
        }
        
    }
    
    func initPhysicsBody()
    {
        scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
    }
    
    
    func updateSceneSizeWithGeometryProxy(_ geometry: GeometryProxy) -> some View {
        if isDyniamicSceneSize {
            DispatchQueue.main.async {
                self.sceneSizeX = geometry.size.width
                self.sceneSizeY = geometry.size.height
            }
        }
        
        return Spacer().frame(width: 0, height: 0).hidden()
    }
    
    func initDynamicPhysicsBody() {
        if selectedPhysicsBodyType == .dynamicPhysicsBody {
            scene.dynamicPhysicsBody.removeFromParent()
            scene.dynamicPhysicsBody = scene.createDynamicPhysicsBody()
            scene.addChild(scene.dynamicPhysicsBody)
            updateDynamicPhysicsBodyRender()
        }
    }
    
    @discardableResult func updateAnchorPoint() -> Bool {
        let numberRange = 0.0...1.0
        if(numberRange.contains(anchorPointX) && numberRange.contains(anchorPointY)) {
            scene.anchorPoint = CGPoint(x: anchorPointX, y: anchorPointY)
            initDynamicPhysicsBody()
            return true
        }
        anchorPointX = scene.anchorPoint.x
        anchorPointY = scene.anchorPoint.y
        return false
    }
}

struct ContentView: View {
    
    #if os(iOS)
    @Environment(\.colorScheme) var colorScheme
    @StateObject var settings = SceneSettings()
    
    @State var isSidebarOpened = true
    
    init() {
        self.isSidebarOpened = isSidebarOpened
    }
    
    var body: some View {
        VStack {
            SpriteView(scene: settings.scene)
                .onAppear {
                    settings.initGameScene()
                }
        }
        .overlay{
            HStack{
                Spacer()
                SidebarView(isSidebarVisiable: $isSidebarOpened, width: 200)
            }
        }
    }
    
    #elseif os(macOS)
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.controlActiveState) var controlActiveState
    
    @StateObject var settings = SceneSettings()
    @State var isSidebarOpened = true
    
    
    init() {
        self.isSidebarOpened = isSidebarOpened
    }
    
    var body: some View {
        HStack{
            VStack {
                GeometryReader { geometry in
                    //settings.updateSceneSizeWithGeometryProxy(geometry)
                    //self.settings.updateSceneSize(x: geometry.size.width, y: geometry.size.height)
                    SpriteView(scene: settings.scene)
                        .onAppear {
                            settings.viewSizeX = geometry.size.width
                            settings.viewSizeY = geometry.size.height
                            settings.initGameScene()
                        }
                        .onChange(of: geometry.size, perform: { newValue in
                            settings.viewSizeX = geometry.size.width
                            settings.viewSizeY = geometry.size.height
                            settings.updateSceenSizeSetting()
                        })
                        .onChange(of: colorScheme) { _ in
                            settings.updateSKColorScheme()}
                        .onChange(of: controlActiveState) { newValue in
                            switch newValue {
                            case .inactive :
                                settings.isPaused = true
                                settings.updatePause()
                            case .key:
                                settings.isPaused = false
                                settings.updatePause()
                            default:
                                break
                            }
                            
                        }
                }
            }
            SidebarView(isSidebarVisiable: $isSidebarOpened, width: 250)
                .environmentObject(settings)
        }
        .navigationTitle("Arcade")
        .toolbar {
            Button {
                settings.isPaused.toggle()
                settings.updatePause()
            } label: {
                Label(settings.isPaused ? "Play" : "Pause",
                      systemImage: settings.isPaused ? "play" : "pause")
            }
            Button{
                withAnimation {
                    isSidebarOpened.toggle()
                }
            } label: {
                Label("Sidebar", systemImage: "sidebar.right")
            }
        }
    }
    #endif
    
}

struct SidebarView: View {
    @EnvironmentObject var settings : SceneSettings
    @Binding var isSidebarVisiable: Bool
    @State var anchorPoint = CGPoint(x: 0.0, y: 0.0)
    
    var width : CGFloat
    
    var body: some View {
        if isSidebarVisiable {
            VStack(alignment: .leading) {
                Group {
                    Text("Scene")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top)
                    
                    HStack {
                        StepperedTextField(name: "X", step: 1.0, value: $settings.sceneSizeX)
                            .onChange(of: settings.sceneSizeX) { newValue in
                                settings.updateSceenSizeSetting()
                            }
                            .disabled(settings.isDyniamicSceneSize)
                        StepperedTextField(name: "Y", step: 1.0, value: $settings.sceneSizeY)
                            .onChange(of: settings.sceneSizeY) { newValue in
                                settings.updateSceenSizeSetting()
                            }
                            .disabled(settings.isDyniamicSceneSize)
                    }
                    
                    Picker("Scale Mode", selection: $settings.selectedScaleMode) {
                        ForEach(settings.scaleModes, id: \.self) { mode in
                            switch mode {
                            case .resizeFill:
                                Text("Resize Fill")
                            case .aspectFit:
                                Text("Aspect Fit")
                            case .aspectFill:
                                Text("Aspect Fill")
                            case .fill:
                                Text("Fill")
                            @unknown default:
                                Text("Unknown")
                            }
                        }
                    }
                    .onChange(of: settings.selectedScaleMode) { newValue in
                        settings.updateSceenSizeSetting()}
                }
                
                
                Divider()
                Text("Anchor Point")
                    .font(.headline)
                    .foregroundColor(.gray)
                    
                HStack {
                    StepperedTextField(name: "X", step: 0.1, value: $settings.anchorPointX)
                        .onChange(of: settings.anchorPointX) { newValue in
                            settings.updateAnchorPoint()
                        }
                    StepperedTextField(name: "Y", step:  0.1, value: $settings.anchorPointY)
                        .onChange(of: settings.anchorPointY) { newValue in
                            settings.updateAnchorPoint()
                        }
                }
                Divider()
                Text("Physics Body")
                    .font(.headline)
                    .foregroundColor(.gray)
                Picker("Type", selection: $settings.selectedPhysicsBodyType) {
                    ForEach(settings.physicsBodyType, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
                .onChange(of: settings.selectedPhysicsBodyType) { type in
                    settings.updatePhysicsBodySetting()
                }
                Toggle("Show Dynamic Physics Body", isOn: $settings.isDynamicPhysicsBodyRendered)
                    .onChange(of: settings.isDynamicPhysicsBodyRendered) { newValue in
                        settings.updateDynamicPhysicsBodyRender()
                    }
                    .disabled(settings.selectedPhysicsBodyType != .dynamicPhysicsBody)
                Spacer()
            }
            .padding(.horizontal)
            .frame(width: width)
        }
    }
}

struct StepperedTextField: View {
    var name : String
    var step : Double
    @Binding var value : Double
    @State var isHovered = false
    var body: some View {
        HStack {
            TextField("", value: $value, format: .number)
                .textFieldStyle(.plain)
                .padding(.leading, 2)
            if isHovered {
                Stepper("", value: $value, step: step)
            } else {
                Text(name)
                    .padding(.vertical, 2)
                    .padding(.trailing, 3)
            }
            
        }
        .onContinuousHover { phase in
            switch phase {
            case .active:
                isHovered = true
            case .ended:
                isHovered = false
            }
        }
        .padding(1)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color("backgroundGray"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
