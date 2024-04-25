//
//  File.swift
//  
//
//  Created by Hardik Modha on 24/04/24.
//

import ComposableArchitecture
import Foundation
import OnboardingSelectPhotoFeature
import OnboardingPhoneNumberFeature
import OnboardingSelectCountryFeature

@Reducer
public struct OnboardingFeature {
    
    public enum ButtonType: Equatable, Hashable, Identifiable {
        case start
        case next
        case cancel
        case submit
        
        public var id: Self {
            self
        }
    }
    
    public enum OnboardingState: Equatable, Hashable, Identifiable {
        case start
        case selectPhoto
        case enterPhoneNumber
        case selectCountry
        case done
        
        var buttons: [ButtonType] {
            switch self {
            case .start:
                return [.start]
            case .selectPhoto:
                return [.cancel, .next]
            case .enterPhoneNumber:
                return [.cancel, .next]
            case .selectCountry:
                return [.cancel, .submit]
            case .done:
                return []
            }
        }
        
        public var id: Self {
            self
        }
    }
    
    @ObservableState
    public struct State: Equatable {
        
        var progress: Double = 0
        var currentStates: [OnboardingState] = [.start]
        var selectPhoto: OnboardingSelectPhotoFeature.State = .init()
        var enterPhoneNumber: OnboardingPhoneNumberFeature.State = .init()
        var selectCountry: OnboardingSelectCountryFeature.State = .init()
        
        public init(progress: Double = 0, currentStates: [OnboardingState] = [.start]) {
            self.currentStates = currentStates
        }
        
        var isNextButtonEnabled: Bool {
            switch currentStates.last ?? .start {
            case .selectPhoto:
                return self.selectPhoto.isFormValid
            case .enterPhoneNumber:
                return self.enterPhoneNumber.isFormValid
            case .selectCountry:
                return self.selectCountry.isFormValid
                
            default:
                return false
            }
        }
    }
    
    public enum Action: Equatable {
        case buttonTapped(ButtonType)
        case selectPhoto(OnboardingSelectPhotoFeature.Action)
        case enterPhoneNumber(OnboardingPhoneNumberFeature.Action)
        case selectCountry(OnboardingSelectCountryFeature.Action)
        case updateProgress
        case backStepButtonTapped
        case homeButtonTapped
        case cancelButtonTapped
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.selectPhoto, action: \.selectPhoto) {
            OnboardingSelectPhotoFeature()
        }
        
        Scope(state: \.enterPhoneNumber, action: \.enterPhoneNumber) {
            OnboardingPhoneNumberFeature()
        }
        
        Scope(state: \.selectCountry, action: \.selectCountry) {
            OnboardingSelectCountryFeature()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .buttonTapped(let buttonType):
                switch buttonType {
                case .cancel:
                    return .send(.cancelButtonTapped)
                    
                case .next:
                    switch state.currentStates.last ?? .start {
                    case .start:
                        state.currentStates = [.selectPhoto]
                        
                    case .selectPhoto:
                        state.currentStates.append(.enterPhoneNumber)
                        
                    case .enterPhoneNumber:
                        state.currentStates.append(.selectCountry)
                        
                    case .selectCountry:
                        state.currentStates.append(.done)
                        
                    case .done:
                        state.currentStates = []
                        break
                    }
                    return .none
                    
                case .start:
                    state.currentStates = [.selectPhoto]
                    return .none
                    
                case .submit:
                    state.currentStates.append(.done)
                    return .none
                }
                
            case .backStepButtonTapped:
                if state.currentStates.last == .start {
                    return .none
                }
                state.currentStates.removeLast()
                if state.currentStates.isEmpty {
                    state.currentStates = [.start]
                }
                return .none
                
            case .enterPhoneNumber(.delegate(.updatedForm)):
                return .send(.updateProgress)
                
            case .enterPhoneNumber:
                return .none
                
            case .selectPhoto(.delegate(.updatedForm)):
                return .send(.updateProgress)
                
            case .selectPhoto:
                return .none
                
            case .selectCountry(.delegate(.updatedForm)):
                return .send(.updateProgress)
                
            case .selectCountry:
                return .send(.updateProgress)
                
            case .updateProgress:
                print("Update progress called")
                let selectPhotoProgres: Double = state.selectPhoto.isFormValid ? 1/3 : 0
                let enterPhoneNumerProgress: Double = state.enterPhoneNumber.isFormValid ? 1/3 : 0
                let selectCountryProgress: Double = state.selectCountry.isFormValid ? 1/3 : 0
                state.progress = selectPhotoProgres + enterPhoneNumerProgress + selectCountryProgress
                print(state.progress)
                return .none
                
            case .homeButtonTapped:
                state.currentStates = [.start]
                return .none
                
            case .cancelButtonTapped:
                switch state.currentStates.last ?? .start {
                case .selectPhoto:
                    return .send(.selectPhoto(.reset)).concatenate(with: .send(.updateProgress))
                case .enterPhoneNumber:
                    return .send(.enterPhoneNumber(.reset)).concatenate(with: .send(.updateProgress))
                case .selectCountry:
                    return .send(.selectCountry(.reset)).concatenate(with: .send(.updateProgress))
                default:
                    return .none
                }
            }
            
        }
    }
}
