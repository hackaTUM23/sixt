//
//  HomeButtonView.swift
//  sixt
//
//  Created by Azarya Bernard on 20.11.22.
//

import Foundation
import SwiftUI

struct HomeButtonview: View {
    
    @Binding var isStarted: Bool
    @Binding var accepted: Bool
    @State var progress = false
    @State var colorAni = false
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let midWidth = width / 2
            ZStack {
                HStack {
                    if isStarted {
                        Text(accepted ? "Preparing..." : "Searching...")
                            .font(.system(size: 24).bold())
                            .foregroundColor(.black)
                            .padding(32)
                            .animation(.easeInOut(duration: 0.75), value: accepted)
                        Spacer()
                    }
                    Image(uiImage: #imageLiteral(resourceName: isStarted ? "CarSide" : "CarIcon"))
                        .resizable()
                        .frame(width: isStarted ? 48 : 64,
                               height: isStarted ? 48 : 64)
                        .offset(x: isStarted && progress ? -50 : 0, y: 0)
                        .opacity(0.9)
                        .padding(isStarted ? 32 : 24)
                }
                // Strokes
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            .linearGradient(.init(colors: [
                                Color.accentColor,
                                Color.accentColor.opacity(0.5),
                                .clear,
                                .clear,
                                Color.accentColor
                            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            , lineWidth: 2.5
                        )
                        .padding(1)
                )
                .background(BlurView(style: .light))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            // Shadows
            .shadow(color: isStarted && colorAni ?
                .accentColor.opacity(0.4) : .black.opacity(0.1),
                    radius: isStarted && colorAni ? 10 : 5, x: -5, y: -5)
            .shadow(color: isStarted && colorAni ?
                .accentColor.opacity(0.4) : .black.opacity(0.1),
                    radius: isStarted && colorAni ? 10 : 5, x: 5, y: 5)
            
            .frame(width: isStarted ? 312 : 96, height: isStarted ? 64 : 96)
            .offset(x: isStarted ? midWidth - 156 : midWidth - 48, y: isStarted ? height - 108 : height - 124)
            .onTapGesture {
                withAnimation(.spring()) {
                    self.isStarted.toggle()
                }
            }
            .id(isStarted)
            .onChange(of: isStarted) { newValue in
                if newValue {
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.825, blendDuration: 0).repeatForever(autoreverses: true)) {
                        progress.toggle()
                    }
                    withAnimation(.easeInOut(duration: 0.95).repeatForever()) {
                        colorAni.toggle()
                    }
                }
            }
        }
    }
}

struct HomeButtonView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeButtonview(isStarted: .constant(false), accepted: .constant(false))
    }
}
