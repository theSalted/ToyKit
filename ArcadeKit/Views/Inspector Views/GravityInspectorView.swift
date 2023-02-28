//
//  GravityInspectorView.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/26/23.
//

import SwiftUI

struct GravityInspectorView: View {
    @StateObject var component : GravitySceneComponentModel
    
    var body: some View {
        Divider()
        SideBarHeader(text: "Gravity", component: component, isRemovable: component.isRemoveable)
        HStack {
            StepperTextFieldView(name: "X", step: 0.1, value: $component.gravityX)
                .onChange(of: component.gravityX) { newValue in
                    component.updateGravity()
                }
            StepperTextFieldView(name: "Y", step: 0.1, value: $component.gravityY)
                .onChange(of: component.gravityY) { newValue in
                    component.updateGravity()
                }
        }
    }
}
