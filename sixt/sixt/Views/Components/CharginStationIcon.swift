//
//  CharginStationIcon.swift
//  sixt
//
//  Created by Martin Fink on 19.11.22.
//

import SwiftUI

struct CharginStationIcon: View {
    var body: some View {
        ZStack {
            Image(systemName: "fuelpump")
            Image(systemName: "bolt.fill")
                .font(.system(size: 5))
                .offset(x: -1.5, y: 4)
        }
    }
}

struct CharginStationIcon_Previews: PreviewProvider {
    static var previews: some View {
        CharginStationIcon()
    }
}
