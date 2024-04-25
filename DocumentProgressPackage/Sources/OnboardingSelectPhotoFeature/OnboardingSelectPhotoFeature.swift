//
//  File.swift
//  
//
//  Created by Hardik Modha on 24/04/24.
//

import ComposableArchitecture
import Foundation
import PhotosUI
import SwiftUI

@Reducer
public struct OnboardingSelectPhotoFeature {
    
    @ObservableState
    public struct State: Equatable {
        var isPhotoPickerPresented: Bool = false
        var imageSelection: PhotosPickerItem?
        var image: Image?
        
        public init() {}
        
        public var isFormValid: Bool {
            self.image != nil
        }
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(_ action: BindingAction<State>)
        case loadedImage(Image?)
        case delegate(Delegate)
        case reset
        
        public enum Delegate {
            case updatedForm
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .binding(\.imageSelection):
                guard let item = state.imageSelection else { return .none }
                return .run { send in
                    let image = try await loadTransferable(from: item)
                    await send(.loadedImage(image))
                } catch: { error, send in
                    print(error)
                }
                
            case .binding:
                return .none
                
            case .delegate:
                return .none
                
            case .loadedImage(let image):
                state.image = image
                return .send(.delegate(.updatedForm))
                
            case .reset:
                state.image = nil
                state.imageSelection = nil
                return .none
            }
        }
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Image? {
        try await imageSelection.loadTransferable(type: Image.self)
    }
    
}

