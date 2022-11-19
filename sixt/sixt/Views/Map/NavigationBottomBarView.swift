//
//  NavigationBottomBarView.swift
//  sixt
//
//  Created by Nikolai Madlener on 19.11.22.
//

import SwiftUI

struct NavigationBottomBarView: View {
//    @EnvironmentObject var model: Model
    @ObservedObject var model = Model.shared
    
    var body: some View {
        Button(action: {
            model.userState = .OpenToWork
            model.objectWillChange.send()
        }) {
            Text("Abbort")
        }.padding(50).background(Color.red)
    }
}

struct NavigationBottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBottomBarView()
    }
}
