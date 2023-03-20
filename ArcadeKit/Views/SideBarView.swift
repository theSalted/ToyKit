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
                
                settings.scene.sceneEntity[ViewSettingSceneComponentModel.self]?.inspectorView()
                
                settings.scene.sceneEntity[AnchorPointSceneComponentModel.self]?.inspectorView()
                
                settings.scene.sceneEntity[PhysicsBodySceneComponentModel.self]?.inspectorView()
                
                settings.scene.sceneEntity[FrictionSceneComponentModel.self]?.inspectorView()
                
                settings.scene.sceneEntity[GravitySceneComponentModel.self]?.inspectorView()
                
                
                ComponentListView().environmentObject(settings)
                
                Spacer()
            }
            .padding()
            .frame(width: width)
        }
    }
}


// TODO: Investigate how to dynamically build view
/*
 ForEach(settings.scene.sceneEntity.components, id: \.self) { component in
     if let viewComponent = component as? InspectorView, !viewComponent.isPriority {
         viewComponent.inspectorView()
     }
 }h
 */
