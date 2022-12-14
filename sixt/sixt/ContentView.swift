//
//  ContentView.swift
//  sixt
//
//  Created by Nikolai Madlener on 18.11.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = Model.shared
    
    var body: some View {
        MapHomeView().environmentObject(model)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
