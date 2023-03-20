//
//  TouchPadCore.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 3/20/23.
//

import SwiftUI

/// A control for selecting values in two dimensions
struct TouchPadCore: View {
    // MARK: Enviromental Properties
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isFocused) private var isFocused
    #if canImport(AppKit)
    @Environment(\.controlActiveState) private var controlActiveState
    #endif
    
    // MARK: Properties
    private var size : CGSize
    
    @Binding private var pointerPosition : CGPoint
    @State private var pointerScale = CGSize(width: 1, height: 1)
    @State private var innerPointerScale = CGSize(width: 1, height: 1)
    @State private var shadowScale = 1.0
    @State private var isPointerDragged = false
    @State private var indicatorPositions : [CGPoint] = [CGPoint]()
    
    // MARK: Constants
    private let touchpadPadding : CGFloat = 10
    
    private let backgroundGradient = LinearGradient(colors: [.white.opacity(0.2), .black.opacity(0.07)],
                                                    startPoint: .top, endPoint: .bottom)
    private let borderGradientLight = LinearGradient(colors: [.gray.opacity(0.4),
                                                              .gray,
                                                              .gray.opacity(0.4),
                                                              .gray],
                                                     startPoint: .topLeading,
                                                     endPoint: .bottomTrailing)
    private let borderGradientDark = LinearGradient(colors: [.gray.opacity(0.8),
                                                             .gray.opacity(0.5),
                                                             .gray.opacity(0.8),
                                                             .gray.opacity(0.5)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing)
    
    // MARK: Inits
    // Convert two values of Binding<Double> to  Binding <CGPoint>
    // Source: https://stackoverflow.com/questions/65541331/converting-two-values-of-type-bindingdouble-to-bindingcgpoint
    public init(size : CGSize, valueX : Binding<Double>, valueY : Binding<Double>) {
        let padding = touchpadPadding
        let viewHeight : CGFloat = size.height - (touchpadPadding * 2)
        let viewWidth : CGFloat = size.width - (touchpadPadding * 2)
        self.size = size
        
        // translate between pointerposition and valure
        self._pointerPosition = Binding<CGPoint>(
                get: { CGPoint(x: (valueX.wrappedValue * viewWidth) + padding, y: (viewHeight + padding) - (valueY.wrappedValue * viewHeight) )},
                set: {  valueX.wrappedValue = Double(($0.x - padding) / viewWidth)
                        valueY.wrappedValue = Double(1 - (($0.y - padding) / viewHeight))
                })
    }
    
    /*
    public init(value: Binding<CGPoint>) {
        self._pointerPosition = value
    }
     */
    
    // MARK: Views
    var body: some View {
        ZStack {
            // Spacer monitor touchpad's tap events
            Spacer()
                .contentShape(Rectangle())
                .onTapGesture { tapLocation in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        // Move pointer's location to where player taplocation
                        pointerPosition = limitToBoundaries(location: tapLocation, parentSize: size)
                    }
                }
        }
        .background {
            background
        }
        .overlay {
            ZStack {
                // Display grids with indicators
                IndicatorsGrid(parentSize: size, touchpadPadding: touchpadPadding, isPointerDragged: $isPointerDragged, pointerPosition: $pointerPosition)
                // Displat pointer
                pointer
                    .position(pointerPosition)
                    .gesture (
                        DragGesture(minimumDistance: 0)
                        // Depending on if pointer is dragger/clicked dispaly shadow and scale animation and change cursor graphics
                            .onChanged { gesture in
                                pointerPosition = limitToBoundaries(location: gesture.location, parentSize: size)
                                #if canImport(AppKit)
                                NSCursor.closedHand.push()
                                #endif
                                isPointerDragged = true
                                withAnimation {
                                    shadowScale = 10
                                    innerPointerScale = CGSize(width: 0.7, height: 0.7)
                                }
                            }
                            .onEnded { gesture in
                                #if canImport(AppKit)
                                NSCursor.pop()
                                #endif
                                isPointerDragged = false
                                withAnimation {
                                    shadowScale = 1
                                    innerPointerScale = CGSize(width: 1, height: 1)
                                }
                            }
                    )
            }
        }
        .frame(width: size.width, height: size.height)
    }
    
    var pointer : some View {
        ZStack {
            // Pointer outer circle - serve as border in most purpose
            Circle()
                .foregroundStyle(.white.opacity(0.7).gradient)
            // Grey out pounter shadow if control is disabled or view is not key on macOS
            #if canImport(AppKit)
                .shadow(color: (isEnabled && controlActiveState == .key) ? .accentColor : .gray,
                        radius: 1 * shadowScale, y: 1)
            #elseif canImport(UIKit)
                .shadow(color: isEnabled ? .accentColor : .gray,
                        radius: 1 * shadowScale, y: 1)
            #endif
                .frame(width: 15)
            
            // Pointer inner circle
            Circle()
            // Grey out inner shadow if control is disabled or view is not key on macOS
            #if canImport(AppKit)
                .foregroundColor((isEnabled && controlActiveState == .key) ? .accentColor : .gray)
            #elseif canImport(UIKit)
                .foregroundColor(isEnabled ? .accentColor : .gray)
            #endif
                .frame(width: 12)
                .scaleEffect(innerPointerScale)
        }
        .onHover { isHovered in
            withAnimation {
                // Scale pointer when hovered
                pointerScale = (isHovered && isEnabled) ? CGSize(width: 1.2, height: 1.2) : CGSize(width: 1, height: 1)
            }
        }
        #if canImport(AppKit)
        .onContinuousHover { hoverPhase in
            // Display open hand cursor when mouse is hovering
            // Uses `onContinuousHover` to get hover location and define trigger area to counter flikering resulted by scale effect
            if isEnabled {
                switch hoverPhase {
                case .active(let location):
                    if location.x <= 10 && location.y <= 10 && !isPointerDragged {
                        NSCursor.openHand.push()
                    }
                case .ended:
                    NSCursor.pop()
                }
            }
        }
        #endif
        .scaleEffect(pointerScale)
        
    }
    
    var background : some View {
        ZStack {
            // Touchpad's gradient background
            RoundedRectangle(cornerRadius: 7)
                .foregroundStyle(
                    backgroundGradient
                )
            
            // Touchpad's gradient border
            RoundedRectangle(cornerRadius: 7)
                .stroke(lineWidth: 1)
                .foregroundStyle(
                    colorScheme == .light ? borderGradientLight : borderGradientDark
                )
        }
    }
    
    // MARK: Functions
    /// Limit input loocation within parentsize + toupadPadding
    private func limitToBoundaries(location : CGPoint, parentSize : CGSize) -> CGPoint {
        var x : CGFloat = 0
        var y : CGFloat = 0
        
        if (touchpadPadding...(parentSize.width - touchpadPadding)).contains(location.x) {
            x = location.x
        } else if location.x < touchpadPadding {
            x = touchpadPadding
        } else if location.x > (parentSize.width - touchpadPadding) {
            x = parentSize.width - touchpadPadding
        }
        
        if (touchpadPadding...(parentSize.height - touchpadPadding)).contains(location.y) {
            y = location.y
        } else if location.y < touchpadPadding {
            y = touchpadPadding
        } else if location.y > (parentSize.height - touchpadPadding) {
            y = parentSize.height - touchpadPadding
        }
        
        return CGPoint(x: x, y: y)
    }
}
