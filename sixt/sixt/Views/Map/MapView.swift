//
//  MapView.swift
//  sixt
//
//  Created by Nikolai Madlener on 19.11.22.
//

import SwiftUI

struct MapView: View {
    
    var body: some View {
        ZStack {
            MapViewRepresentable()
                .ignoresSafeArea(.all)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
