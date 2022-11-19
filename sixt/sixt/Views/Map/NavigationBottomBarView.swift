//
//  NavigationBottomBarView.swift
//  sixt
//
//  Created by Nikolai Madlener on 19.11.22.
//

import SwiftUI

struct NavigationBottomBarView: View {
    @EnvironmentObject var model: Model

    let onDismiss: (() -> Void)
    
    var body: some View {
        Button(action: {
            onDismiss()
        }) {
            Text("Abbort")
        }.padding(50).background(Color.red)
    }
}

struct NavigationBottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBottomBarView(onDismiss: {})
    }
}
