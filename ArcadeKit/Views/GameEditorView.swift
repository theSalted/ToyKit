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
        HStack{
            VStack {
                GeometryReader { geometry in
                    SpriteView(scene: settings.scene)
                        .onAppear {
                            settings.viewSizeX = geometry.size.width
                            settings.viewSizeY = geometry.size.height
                            settings.initGameScene()
                        }
                        .onChange(of: geometry.size, perform: { newValue in
                            settings.viewSizeX = geometry.size.width
                            settings.viewSizeY = geometry.size.height
                            settings.updateSceneSizeSetting()
                        })
                        .onChange(of: colorScheme) { _ in
                            settings.updateSKColorScheme()}
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
