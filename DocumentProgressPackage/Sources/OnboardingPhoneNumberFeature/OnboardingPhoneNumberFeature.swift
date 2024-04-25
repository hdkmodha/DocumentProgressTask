//
//  File.swift
//  
//
//  Created by Hardik Modha on 24/04/24.
//

import ComposableArchitecture
import Foundation
import Photos
import PhotosUI
import SwiftUI

@Reducer
public struct OnboardingPhoneNumberFeature {
    
    @ObservableState
    public struct State: Equatable {
        var phoneNumber: String
        
        public init(phoneNumber: String = "") {
            self.phoneNumber = phoneNumber
        }
        
        public var isFormValid: Bool {
            !self.phoneNumber.isEmpty && self.phoneNumber.count == 10
        }
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(_ action: BindingAction<State>)
        case delegate(Delegate)
        case reset
        
        public enum Delegate {
            case updatedForm
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
            .onChange(of: \.phoneNumber) { oldValue, newValue in
                Reduce { state, action in
                    return .send(.delegate(.updatedForm))
                }
            }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .binding:
                return .none
            case .delegate:
                return .none
            case .reset:
                state.phoneNumber = ""
                return .none
            }
        }
    }
}
