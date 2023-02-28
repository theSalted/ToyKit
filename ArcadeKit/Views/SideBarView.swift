//
//  SideBarView.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/22/23.
//

import SwiftUI
import GameplayKit

struct SidebarView: View {
    @EnvironmentObject var settings : SceneSetting
    @Binding var isSidebarVisiable: Bool
    @State var anchorPoint = CGPoint(x: 0.0, y: 0.0)
    
    var width : CGFloat
    
    var body: some View {
        if isSidebarVisiable {
            VStack(alignment: .center) {
                Group {
                    SideBarHeader(text: "Scene")
                    
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
                    SideBarHeader(text: "Anchor Point")
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
                
                settings.scene.sceneEntity[PhysicsBodySceneComponentModel.self]?.inspectorView()
                
                settings.scene.sceneEntity[FrictionSceneComponentModel.self]?.inspectorView()
                
                settings.scene.sceneEntity[GravitySceneComponentModel.self]?.inspectorView()
                
                ComponentListView()
                    .environmentObject(settings)
                
                Spacer()
            }
            .padding()
            .frame(width: width)
        }
    }
}
