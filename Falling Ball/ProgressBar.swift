//
//  ProgressBar.swift
//  Falling Ball
//
//  Created by Ethan Humphrey on 3/3/20.
//  Copyright © 2020 Ethan Humphrey. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    @State var value: CGFloat
    @State var accentColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .opacity(0.1)
                Rectangle()
                    .frame(minWidth: 0, idealWidth:self.getProgressBarWidth(geometry: geometry),
                           maxWidth: self.getProgressBarWidth(geometry: geometry))
                    .foregroundColor(self.accentColor)
                    .animation(.default)
            }
            .cornerRadius(5)
        }
        .frame(height:10)
    }
    
    func getProgressBarWidth(geometry:GeometryProxy) -> CGFloat {
        let frame = geometry.frame(in: .global)
        return frame.size.width * value
    }

    func getPercentage(_ value:CGFloat) -> String {
        let intValue = Int(ceil(value * 100))
        return "\(intValue) %"
    }
}
