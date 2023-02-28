//
//  FrictionInspectorView.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/27/23.
//

import SwiftUI

struct FrictionInspectorView: View {
    @StateObject var component : FrictionSceneComponentModel
    
    var body: some View {
        Divider()
        SideBarHeader(text: "Friction")
            .font(.headline)
            .foregroundColor(.gray)
        StepperTextFieldView(name: "Friction", step: 0.1, value: $component.friction)
            .onChange(of: component.friction) { newValue in
                // void changes if its invalidate
                if component.validateFriction(friction: newValue) {
                    component.updateFriction()
                } else {
                    if newValue > 1 {
                        component.setFriction(friction: 1)
                    } else {
                        component.setFriction(friction: 0)
                    }
                    
                }
            }
            .disabled(!component.checkPrerequisiteAndEnvironmentCompliance())
        Slider(value: $component.friction)
            .disabled(!component.checkPrerequisiteAndEnvironmentCompliance())
        
        if !component.checkPrerequisiteAndEnvironmentCompliance() {
            HStack {
                Text("This component is deactivated because a required cocomponent is missing.")
                Button {
                    component.checkPrerequisiteAndEnvironmentCompliance()
                    component.objectWillChange.send()
                } label: {
                    Image(systemName: "arrow.2.circlepath")
                }
            }
            .font(.caption)
        }
        
    }
}
