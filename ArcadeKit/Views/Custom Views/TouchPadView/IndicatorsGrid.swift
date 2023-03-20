//
//  IndicatorsGrid.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 3/20/23.
//

import SwiftUI

/// A grid of indicators
struct IndicatorsGrid: View {
    // MARK: Properties
    var parentSize : CGSize
    var touchpadPadding : CGFloat
    @Binding var isPointerDragged : Bool
    @Binding var pointerPosition : CGPoint
    
    // MARK: Views
    var body: some View {
        HStack {
            VStack {
                TocuhpadIndicator(imageName: "top.leading", position: .topLeading, parentSize: parentSize, touchPadPadding: touchpadPadding, isPointerDragged: $isPointerDragged, pointerPosition: $pointerPosition)
                    .padding(.top, touchpadPadding/2)
                Spacer()
                TocuhpadIndicator(imageName: "leading", position: .leading, parentSize: parentSize, touchPadPadding: touchpadPadding, isPointerDragged: $isPointerDragged, pointerPosition: $pointerPosition)
                Spacer()
                TocuhpadIndicator(imageName: "bottom.leading", position: .bottomLeading, parentSize: parentSize, touchPadPadding: touchpadPadding, isPointerDragged: $isPointerDragged, pointerPosition: $pointerPosition)
                    .padding(.bottom, touchpadPadding/2)
            }
            .padding(.leading, touchpadPadding/2)
            Spacer()
            VStack {
                TocuhpadIndicator(imageName: "top", position: .top, parentSize: parentSize, touchPadPadding: touchpadPadding, isPointerDragged: $isPointerDragged, pointerPosition: $pointerPosition)
                    .padding(.top, touchpadPadding/2)
                Spacer()
                TocuhpadIndicator(imageName: "plus", position: .center, parentSize: parentSize, touchPadPadding: touchpadPadding, isPointerDragged: $isPointerDragged, pointerPosition: $pointerPosition)
                Spacer()
                TocuhpadIndicator(imageName: "bottom", position: .bottom, parentSize: parentSize, touchPadPadding: touchpadPadding, isPointerDragged: $isPointerDragged, pointerPosition: $pointerPosition)
                    .padding(.bottom, touchpadPadding/2)
            }
            Spacer()
            VStack {
                TocuhpadIndicator(imageName: "top.trailing", position: .topTrailing, parentSize: parentSize, touchPadPadding: touchpadPadding, isPointerDragged: $isPointerDragged, pointerPosition: $pointerPosition)
                    .padding(.top, touchpadPadding/2)
                Spacer()
                TocuhpadIndicator(imageName: "trailing", position: .trailing, parentSize: parentSize, touchPadPadding: touchpadPadding, isPointerDragged: $isPointerDragged, pointerPosition: $pointerPosition)
                Spacer()
                TocuhpadIndicator(imageName: "bottom.trailing", position: .bottomTrailing, parentSize: parentSize, touchPadPadding: touchpadPadding, isPointerDragged: $isPointerDragged, pointerPosition: $pointerPosition)
                    .padding(.bottom, touchpadPadding/2)
            }
            .padding(.trailing, touchpadPadding/2)
        }
    }
}
