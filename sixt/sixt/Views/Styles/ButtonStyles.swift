//
//  FilledButtonStyle.swift
//  sixt
//
//  Created by Martin Fink on 19.11.22.
//

import Foundation
import SwiftUI

struct FilledButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(isEnabled ? Color.accentColor.opacity(configuration.isPressed ? 0.3 : 1.0) : .gray)
            .cornerRadius(8)
    }
}

struct OutlineButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(.accentColor.opacity(configuration.isPressed ? 0.3 : 1.0))
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(
                    cornerRadius: 8,
                    style: .continuous
                ).stroke(Color.accentColor.opacity(configuration.isPressed ? 0.3 : 1.0))
        )
    }
}
