//
//  File.swift
//  
//
//  Created by Hardik Modha on 24/04/24.
//

import Foundation
import SwiftUI

public struct AppButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(isEnabled ? Color.accentColor : Color.gray, in: .rect(cornerRadius: 12, style: .continuous))
            .foregroundStyle(.white)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .fontWeight(.semibold)
            .opacity(isEnabled ? 1 : 0.8)
    }
}

extension ButtonStyle where Self == AppButtonStyle {
    public static var appDefault: some ButtonStyle {
        AppButtonStyle()
    }
}

#Preview {
    Button(action: { print("Pressed") }) {
        Label("Press Me", systemImage: "star")
    }
    .buttonStyle(AppButtonStyle())
    .disabled(true)
}
