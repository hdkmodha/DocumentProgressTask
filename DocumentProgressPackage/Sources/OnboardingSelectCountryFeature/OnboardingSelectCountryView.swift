//
//  File.swift
//  
//
//  Created by Hardik Modha on 24/04/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import UIUtilities

public struct OnboardingSelectCountryView: View {
    let store: StoreOf<OnboardingSelectCountryFeature>
    
    public init(store: StoreOf<OnboardingSelectCountryFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            FetchingView(state: store.countries, title: "Countries") { countries in
                Menu {
                    ForEach(countries, id: \.name.common) { contry in
                        Button {
                            store.send(.selectCountry(contry))
                        } label: {
                            HStack {
                                if contry == store.selectedCountry {
                                    Image(systemName: "checkmark")
                                }
                                Text("\(contry.flag) \(contry.displayName)")
                            }
                        }
                    }
                } label: {
                    HStack {
                        if let selectedCountryFlag = store.selectedCountry?.flag {
                            Text(selectedCountryFlag)
                        }
                        Text(store.selectedCountry?.displayName ?? "Select Country")
                    }
                }
            }
        }
        .padding()
        .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    OnboardingSelectCountryView(store: .init(initialState: .init(), reducer: {
        OnboardingSelectCountryFeature()
    }))
}

