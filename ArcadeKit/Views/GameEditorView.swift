//
//  ContentView.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/16/23.
//

import SwiftUI
import OctopusKit
import SpriteKit
import GameplayKit
import GameController


struct GameEditorView: View {
    
    #if os(iOS)
    @Environment(\.colorScheme) var colorScheme
    @StateObject var settings = SceneSettingsModel()
    
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
    
    @StateObject var settings = SceneSettingsModel()
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
    @EnvironmentObject var settings : SceneSettingsModel
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
                        StepperTextFieldView(name: "X", step: 1.0, value: $settings.sceneSizeX)
                            .onChange(of: settings.sceneSizeX) { newValue in
                                settings.updateSceenSizeSetting()
                            }
                            .disabled(settings.isDyniamicSceneSize)
                        StepperTextFieldView(name: "Y", step: 1.0, value: $settings.sceneSizeY)
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
                    StepperTextFieldView(name: "X", step: 0.1, value: $settings.anchorPointX)
                        .onChange(of: settings.anchorPointX) { newValue in
                            settings.updateAnchorPoint()
                        }
                    StepperTextFieldView(name: "Y", step:  0.1, value: $settings.anchorPointY)
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameEditorView()
    }
}
