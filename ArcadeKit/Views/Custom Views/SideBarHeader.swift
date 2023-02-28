//
//  SideBarHeader.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/27/23.
//

import SwiftUI
import GameplayKit

struct SideBarHeader: View {
    @EnvironmentObject var settings : SceneSetting
    var text: String
    var component: GKComponent?
    var isRemovable = true
    
    var body: some View {
        HStack {
            Text(text)
                .font(.headline)
            Spacer()
            if isRemovable, let unwrappedComponent = component {
                Button {
                    settings.removeComponent(component: unwrappedComponent)
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonStyle(.plain)
                .font(.caption)
            }
        }
        .foregroundColor(.gray)
    }
}
