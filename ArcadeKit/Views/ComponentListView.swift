//
//  ComponentListView.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/27/23.
//

import SwiftUI
import GameplayKit

struct ComponentListView: View {
    @EnvironmentObject var settings : SceneSetting
    @State var componentListSelection : GKComponent?
    
    var body: some View {
        Group {
            Divider()
            HStack {
                Text("Components")
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
                Menu {
                    ForEach(settings.avaliableComponent, id: \.self) { component in
                        Button {
                            settings.addComponent(component: component)
                        } label: {
                            Text(String(describing: type(of: component)))
                        }

                    }
                } label: {
                    // TODO: Make a custom menu style
                    Text("Add Component")
                }
                
            }
            List(settings.scene.sceneEntity.components, id: \.self, selection: $componentListSelection) { component in
                ComponentListItem(component: component)
                    .environmentObject(settings)
            }
            .onDeleteCommand {
                if let component = componentListSelection {
                    settings.removeComponent(component: component)
                }
            }
        }
    }
}
