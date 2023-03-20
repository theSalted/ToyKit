//
//  ViewSettingInspectorView.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/28/23.
//

import SwiftUI

struct ViewSettingInspectorView: View {
    @StateObject var component : ViewSettingSceneComponentModel
    
    var body: some View {
        
        HStack {
            StepperTextFieldView(name: "X", step: 1.0, value: $component.sceneSizeX)
                .onChange(of: component.sceneSizeX) { newValue in
                    component.updateViewSizeSetting()
                }
                .disabled(component.isDyniamicSceneSize)
            StepperTextFieldView(name: "Y", step: 1.0, value: $component.sceneSizeY)
                .onChange(of: component.sceneSizeY) { newValue in
                    component.updateViewSizeSetting()
                }
                .disabled(component.isDyniamicSceneSize)
        }
        
        Picker("Scale Mode", selection: $component.selectedScaleMode) {
            ForEach(component.scaleModes, id: \.self) { mode in
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
        .onChange(of: component.selectedScaleMode) { newValue in
            component.updateViewSizeSetting()}
    }
}
