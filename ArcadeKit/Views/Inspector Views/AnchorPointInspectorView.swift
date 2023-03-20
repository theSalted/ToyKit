//
//  AnchorPointInspectorView.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/27/23.
//

import SwiftUI

struct AnchorPointInspectorView: View {
    @StateObject var component : AnchorPointSceneComponentModel
    
    var body: some View {
        Divider()
        SideBarHeader(text: "Anchor Point", component: component, isRemovable: component.isRemoveable)
        
        HStack(alignment: .center) {
            VStack {
                StepperTextFieldView(name: "X", step: 0.1, value: $component.anchorPointX)
                    .onChange(of: component.anchorPointX) { newValue in
                        component.updateAnchorPoint()
                    }
                StepperTextFieldView(name: "Y", step:  0.1, value: $component.anchorPointY)
                    .onChange(of: component.anchorPointY) { newValue in
                        component.updateAnchorPoint()
                    }
            }
            
            TouchPadView(valueX: $component.anchorPointX, valueY: $component.anchorPointY)
                .frame(height: 55)
    
        }
    }
}
