//
//  ComponentListItem.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/27/23.
//

import SwiftUI
import GameplayKit

struct ComponentListItem: View {
    @EnvironmentObject var settings : SceneSetting
    var component : GKComponent
    
    var body: some View {
        HStack {
            Text(String(describing: type(of: component)))
                .lineLimit(1)
            Spacer()
            Button {
                settings.removeComponent(component: component)
            } label: {
                Image(systemName: "xmark")
            }
            .buttonStyle(.plain)
        }
        .font(.callout)
        .contextMenu{
            Button {
                settings.removeComponent(component: component)
            } label: {
                Label("Remove Component", image: "xmark")
            }
            
        }
    }
}
