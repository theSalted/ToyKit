//
//  SideBarView.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/22/23.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var settings : SceneSetting
    @Binding var isSidebarVisiable: Bool
    @State var anchorPoint = CGPoint(x: 0.0, y: 0.0)
    
    var width : CGFloat
    
    var body: some View {
        if isSidebarVisiable {
            VStack(alignment: .center) {
                Group {
                    SideBarHeaderView(text: "Scene")
                    
                    HStack {
                        StepperTextFieldView(name: "X", step: 1.0, value: $settings.sceneSizeX)
                            .onChange(of: settings.sceneSizeX) { newValue in
                                settings.updateSceneSizeSetting()
                            }
                            .disabled(settings.isDyniamicSceneSize)
                        StepperTextFieldView(name: "Y", step: 1.0, value: $settings.sceneSizeY)
                            .onChange(of: settings.sceneSizeY) { newValue in
                                settings.updateSceneSizeSetting()
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
                        settings.updateSceneSizeSetting()}
                }
                
                
                Group {
                    Divider()
                    SideBarHeaderView(text: "Anchor Point")
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
                }
                
                Group {
                    Divider()
                    SideBarHeaderView(text: "Physics Body")
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
                }
                
                Group {
                    Divider()
                    SideBarHeaderView(text: "Components")
                        .font(.headline)
                        .foregroundColor(.gray)
                    List {
                        ForEach(settings.scene.sceneEntity.components, id: \.self) { component in
                            Text(String(describing: type(of: component)))
                        }
                    }
                    
                }
                
                Spacer()
                
            }
            .padding()
            .frame(width: width)
        }
    }
}


struct SideBarHeaderView: View {
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.headline)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}
