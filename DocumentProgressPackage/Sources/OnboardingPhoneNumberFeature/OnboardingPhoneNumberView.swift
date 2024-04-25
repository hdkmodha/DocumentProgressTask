//
//  File.swift
//  
//
//  Created by Hardik Modha on 24/04/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI

public struct OnboardingPhoneNumberView: View {
    @Bindable var store: StoreOf<OnboardingPhoneNumberFeature>
    
    public init(store: StoreOf<OnboardingPhoneNumberFeature>) {
        self.store = store
    }
    
    public var body: some View {
        TextField("Phone number", text: $store.phoneNumber)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.phonePad)
            .padding()
    }
}

#Preview {
    OnboardingPhoneNumberView(store: .init(initialState: .init(), reducer: {
        OnboardingPhoneNumberFeature()
    }))
}
