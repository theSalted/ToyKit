//
//  StepperTextFieldView.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/22/23.
//

import SwiftUI

struct StepperTextFieldView: View {
    var name : String
    var step : Double
    @Binding var value : Double
    @State var isHovered = false
    var body: some View {
        HStack {
            TextField("", value: $value, format: .number)
                .textFieldStyle(.plain)
                .padding(.leading, 2)
                .padding(.vertical, 2)
            if isHovered {
                Stepper("", value: $value, step: step)
            } else {
                Text(name)
                    .font(.caption)
                    .padding(.trailing, 3)
            }
            
        }
        .onContinuousHover { phase in
            switch phase {
            case .active:
                isHovered = true
            case .ended:
                isHovered = false
            }
        }
        .padding(1)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color("backgroundGray"))
        }
    }
}
