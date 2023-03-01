//
//  ContentView.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/16/23.
//

import SwiftUI
import SpriteKit


struct GameEditorView: View {
    #if os(macOS)
    @Environment(\.controlActiveState) var controlActiveState
    #endif
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var settings = SceneSetting()
    @State var isSidebarOpened = true
    
    init() {
        self.isSidebarOpened = isSidebarOpened
    }
    
    var body: some View {
        HStack(spacing: 0){
            VStack {
                GeometryReader { geometry in
                    SpriteView(scene: settings.scene)
                        .onAppear {
                            settings.scene.sceneEntity[ViewSettingSceneComponentModel.self]?.setViewSize(size: geometry.size)
                            settings.initGameScene()
                        }
                        .onChange(of: geometry.size, perform: { newValue in
                            settings.scene.sceneEntity[ViewSettingSceneComponentModel.self]?.setViewSize(size: geometry.size)
                            settings.scene.sceneEntity[ViewSettingSceneComponentModel.self]?.updateViewSizeSetting()
                        })
                        .onChange(of: colorScheme) { _ in
                            settings.scene.sceneEntity[BackgroundColorSchemeSceneComponent.self]?.updateSKColorScheme()
                        }
                    #if os(macOS)
                        .onChange(of: controlActiveState) { newValue in
                            switch newValue {
                            case .inactive :
                                settings.updatePauseWith(shouldPause: true)
                            case .key:
                                settings.updatePauseWith(shouldPause: false)
                            default:
                                break
                            }
                        }
                    #elseif os(iOS)
                        .ignoresSafeArea()
                    #endif
                }
            }
            #if os(iOS)
            .overlay {
                HStack {
                    Spacer()
                    SidebarView(isSidebarVisiable: $isSidebarOpened, width: 200)
                        .environmentObject(settings)
                }
                
            }
            #endif
            
            #if os(macOS)
            SidebarView(isSidebarVisiable: $isSidebarOpened, width: 250)
                .environmentObject(settings)
            #endif
        }
        .navigationTitle("Arcade")
        .toolbar {
            Button {
                settings.isPaused.toggle()
                settings.updatePause()
            } label: {
                Label(settings.isPaused ? "Play" : "Pause",
                      systemImage: settings.isPaused ? "play" : "pause")
            }
            Button{
                withAnimation {
                    isSidebarOpened.toggle()
                }
            } label: {
                Label("Sidebar", systemImage: "sidebar.right")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameEditorView()
    }
}
