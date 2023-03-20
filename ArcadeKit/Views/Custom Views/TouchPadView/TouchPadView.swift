//
//  ContentView.swift
//  Arcade Design
//
//  Created by Yuhao Chen on 3/7/23.
//

import SwiftUI
#if canImport(Coca)
import Cocoa
#endif

struct TouchPadView: View {
    @Binding var valueX : Double
    @Binding var valueY : Double
    
    var body: some View {
        GeometryReader { geometry in
            TouchPadCore(size: geometry.size, valueX: $valueX, valueY: $valueY)
        }
    }
}
