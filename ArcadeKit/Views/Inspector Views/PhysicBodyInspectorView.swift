//
//  PhysicBodyInspectorView.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/25/23.
//

import SwiftUI

struct PhysicBodyInspectorView: View {
    @StateObject var component : PhysicsBodySceneComponentModel
    
    var body: some View {
        Divider()
        SideBarHeader(text: "Physics Body")
            .font(.headline)
            .foregroundColor(.gray)
        Picker("Type", selection: $component.physicsBodyType) {
            ForEach(PhysicsBodyType.allCases, id: \.self) { type in
                Text(type.rawValue)
            }
        }
        .onChange(of: component.physicsBodyType) { type in
            component.updatePhysicsBodySetting()
        }
        Toggle("Show Dynamic Physics Body", isOn: $component.isDynamicPhysicsBodyRendered)
            .onChange(of: component.isDynamicPhysicsBodyRendered) { newValue in
                component.updateDynamicPhysicsBodyRender()
            }
            .disabled(component.physicsBodyType != .dynamicPhysicsBody)
    }
}
