//
//  ContentView.swift
//  sixt
//
//  Created by Nikolai Madlener on 18.11.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var user: User = User()
    
    var body: some View {
        MapHomeView().environmentObject(user)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
