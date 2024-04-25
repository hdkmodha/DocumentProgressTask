//
//  DocumentProgressTaskApp.swift
//  DocumentProgressTask
//
//  Created by Hardik Modha on 24/04/24.
//

import ComposableArchitecture
import OnboardingFeature
import SwiftUI

@main
struct DocumentProgressTaskApp: App {
    
    let store: StoreOf<OnboardingFeature> = .init(initialState: .init()) {
        OnboardingFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            OnboardingView(store: store)
        }
    }
}
