//
//  AnimatedBackground.swift
//  sixt
//
//  Created by Nikolai Madlener on 19.11.22.
//

import SwiftUI

struct AnimatedBackground: View {
    @State var start = UnitPoint.leading
    @State var end = UnitPoint.trailing

    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let colors: [Color] = [.orange, .yellow]

    var body: some View {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .animation(Animation.easeInOut(duration: 3).repeatForever(), value: start) /// don't forget the `value`!
            .onReceive(timer) { _ in
                
                self.start = nextPointFrom(self.start)
                self.end = nextPointFrom(self.end)

            }
            .edgesIgnoringSafeArea(.all)
    }
    
    /// cycle to the next point
    func nextPointFrom(_ currentPoint: UnitPoint) -> UnitPoint {
        switch currentPoint {
        case .top:
            return .topLeading
        case .topLeading:
            return .leading
        case .leading:
            return .bottomLeading
        case .bottomLeading:
            return .bottom
        case .bottom:
            return .bottomTrailing
        case .bottomTrailing:
            return .trailing
        case .trailing:
            return .topTrailing
        case .topTrailing:
            return .top
        default:
            print("Unknown point")
            return .top
        }
    }
}
