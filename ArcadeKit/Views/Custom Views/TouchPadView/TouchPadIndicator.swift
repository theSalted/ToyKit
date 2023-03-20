//
//  TouchPadIndicator.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 3/20/23.
//

import SwiftUI

/// Display custom SFSymbol based on UnitPoint position
struct TocuhpadIndicator: View {
    @Environment(\.isEnabled) var isEnabled
    // MARK: Properties
    @Binding var isPointerDragged : Bool
    @Binding var pointerPosition : CGPoint
    
    @State var isPointerInRange = false
    @State private var color = Color.gray
    
    // MARK: Constants
    #if canImport(AppKit)
    /// Haptic performer for macOS
    let performer = NSHapticFeedbackManager.defaultPerformer
    #endif
    var position : UnitPoint
    var detailedPos : CGPoint
    var xRange : (ClosedRange<CGFloat>)
    var yRange : (ClosedRange<CGFloat>)
    var image : Image
    
    init(imageName: String, position: UnitPoint, parentSize: CGSize, touchPadPadding: CGFloat, isPointerDragged: Binding<Bool>, pointerPosition: Binding<CGPoint>, isPointerInRange: Bool = false, color: SwiftUI.Color = Color.gray) {
        
        self.position = position
        self._isPointerDragged = isPointerDragged
        self._pointerPosition = pointerPosition
        self.isPointerInRange = isPointerInRange
        self.color = color
        
        // pre-translate unipoint to CGPoint so this translation is only calculate once
        switch position {
        case .center:
            self.detailedPos = CGPoint(x: parentSize.width/2, y: parentSize.height/2)
        case .bottom:
            self.detailedPos = CGPoint(x: parentSize.width/2, y: parentSize.height - touchPadPadding)
        case .top:
            self.detailedPos = CGPoint(x: parentSize.width/2, y: touchPadPadding)
        case .leading:
            self.detailedPos = CGPoint(x: touchPadPadding, y: parentSize.height/2)
        case .trailing:
            self.detailedPos = CGPoint(x: parentSize.width - touchPadPadding, y: parentSize.height/2)
        case .topLeading:
            self.detailedPos = CGPoint(x: touchPadPadding, y: touchPadPadding)
        case .topTrailing:
            self.detailedPos = CGPoint(x: parentSize.width - touchPadPadding, y: touchPadPadding)
        case .bottomLeading:
            self.detailedPos = CGPoint(x: touchPadPadding, y: parentSize.height - touchPadPadding)
        case .bottomTrailing:
            self.detailedPos = CGPoint(x: parentSize.width - touchPadPadding, y: parentSize.height - touchPadPadding)
        default:
            self.detailedPos = CGPoint(x: 0, y: 0)
        }
        
        self.xRange = ((self.detailedPos.x - 10)...(self.detailedPos.x + 10))
        self.yRange = ((self.detailedPos.y - 10)...(self.detailedPos.y + 10))
        
        if imageName == "plus" {
            self.image = Image(systemName: imageName)
        } else {
            self.image = Image(imageName)
        }
    }
    
    // MARK: Views
    var body: some View {
        image
            .imageScale(.small)
            .foregroundStyle(color.gradient)
            .onChange(of: pointerPosition) { newPosition in
                // change indicator color back to gray when pointer is moved,
                // this is done to fix an issue where indicator stuck on green
                color = Color.gray
                // monitor pointer position and update property if pointer is in range of the pointer
                isPointerInRange = xRange.contains(newPosition.x) && yRange.contains(newPosition.y)
            }
            .onHover { isHovered in
                // change color base on hover state
                color = (isHovered && isEnabled) ? Color.accentColor : Color.gray
            }
            .onTapGesture { _ in
                withAnimation(.easeInOut(duration: 0.2)) {
                    // move pointer to indicator's position on tap
                    pointerPosition = detailedPos
                }
            }
            .onChange(of: isPointerDragged) { newValue in
                // snap pointer to indicator's position when pointer is released near indicatoe
                if !newValue && isPointerInRange {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        pointerPosition = detailedPos
                    }
                }
            }
        #if canImport(AppKit)
            .onChange(of: isPointerInRange) { newValue in
                // provide haptic feedback when pointer is dragger near
                if newValue && isPointerDragged {
                    performer.perform(.alignment, performanceTime: .now)
                }
            }
        #endif
    }
}

struct TouchPadView_Previews: PreviewProvider {
    static var previews: some View {
        TouchPadView(valueX: .constant(1), valueY: .constant(1))
            .padding()
    }
}
