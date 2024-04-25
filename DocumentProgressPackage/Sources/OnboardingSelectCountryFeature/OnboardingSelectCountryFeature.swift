//
//  File.swift
//  
//
//  Created by Hardik Modha on 24/04/24.
//

import ComposableArchitecture
import Foundation
import UIUtilities

public struct Country: Codable, Equatable {
    public struct Name: Codable, Equatable {
        public var common: String
        public var official: String
        
        public init(common: String, official: String) {
            self.common = common
            self.official = official
        }
    }
    
    
    public var name: Name
    public var flag: String
    
    public init(name: Name, flag: String) {
        self.name = name
        self.flag = flag
    }
    
    public var displayName: String {
        self.name.common
    }
}

@Reducer
public struct OnboardingSelectCountryFeature {
    
    @ObservableState
    public struct State: Equatable {
        var countries: FetchingState<[Country]> = .fetching
        var selectedCountry: Country?
        public init() {}
        
        public var isFormValid: Bool {
            self.selectedCountry != nil
        }
    }
    
    public enum Action: Equatable {
        case onAppear
        case receivedContries(FetchingState<[Country]>)
        case selectCountry(Country)
        case delegate(Delegate)
        case reset
        
        public enum Delegate {
            case updatedForm
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .delegate:
                return .none
                
            case .onAppear:
                state.countries = .fetching
                return .run { send in
                    let contries = try await fetchCountries()
                    await send(.receivedContries(.fetched(contries)))
                } catch: { error, send in
                    await send(.receivedContries(.error(error.localizedDescription)))
                }
            case .receivedContries(let contries):
                state.countries = contries
                return .none
                
            case .selectCountry(let country):
                state.selectedCountry = country
                return .send(.delegate(.updatedForm))
                
            case .reset:
                state.selectedCountry = nil
                return .none
            }
        }
    }
    
    private func fetchCountries() async throws -> [Country] {
        let url = URL(string: "https://restcountries.com/v3.1/all")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode([Country].self, from: data)
        print("Countries: \(decoded)")
        return decoded
    }
}
