//
//  SideBarHeader.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/27/23.
//

import SwiftUI

struct SideBarHeader: View {
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.headline)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}
