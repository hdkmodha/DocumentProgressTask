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
import OnboardingSelectPhotoFeature
import OnboardingSelectCountryFeature
import OnboardingPhoneNumberFeature

public struct OnboardingView: View {
    let store: StoreOf<OnboardingFeature>
    @Namespace private var namespace
    
    public init(store: StoreOf<OnboardingFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            horizontalProgressHeader
            Spacer()
            currentFeatureStack
            Spacer()
            buttonStack
            if store.currentStates.last != .start {
                Button {
                    store.send(.homeButtonTapped)
                } label: {
                    Image(systemName: "house.circle.fill")
                }
                .font(.largeTitle)
                .padding()
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .safeAreaInset(edge: .top) {
            HStack {
                if store.currentStates.last != .start {
                    Button {
                        store.send(.backStepButtonTapped)
                    } label: {
                        Label("Information", systemImage: "chevron.backward.circle.fill")
                    }
                    Spacer()
                }
                
            }
            .padding(.horizontal)
        }
    }
    
    var currentFeatureStack: some View {
        VStack {
            ForEach(store.currentStates) { currentState in
                switch (currentState) {
                case .start:
                    Text("Document Details")
                        .matchedGeometryEffect(id: "title", in: namespace)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.accentColor)
                    
                case .selectPhoto:
                    OnboardingSelectPhotoView(store: store.scope(state: \.selectPhoto, action: \.selectPhoto))
                    
                case .enterPhoneNumber:
                    OnboardingPhoneNumberView(store: store.scope(state: \.enterPhoneNumber, action: \.enterPhoneNumber))
                    
                case .selectCountry:
                    OnboardingSelectCountryView(store: store.scope(state: \.selectCountry, action: \.selectCountry))
                    
                case .done:
                    EmptyView()
                }
            }
        }
        .animation(.smooth, value: store.currentStates.last != .start)
    }
    
    var buttonStack: some View {
        HStack {
            ForEach((store.currentStates.last ?? .start).buttons) { button in
                switch button {
                case .cancel:
                    Button("Cancel") {
                        store.send(.buttonTapped(.cancel))
                    }
                    
                case .next:
                    Button("Next") {
                        store.send(.buttonTapped(.next), animation: .smooth)
                    }
                    .disabled(!self.store.isNextButtonEnabled)
                    
                case .submit:
                    Button("Submit") {
                        store.send(.buttonTapped(.submit))
                    }
                    .disabled(!self.store.isNextButtonEnabled)
                    
                case .start:
                    Button {
                        store.send(.buttonTapped(.start))
                    } label: {
                        Text("Start")
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .buttonStyle(.appDefault)
    }
    
    var horizontalProgressHeader: some View {
        HStack {
            if store.currentStates.last != .start {
                Text("Document Details")
                    .matchedGeometryEffect(id: "title", in: namespace)
                    .font(.title3)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.accentColor)
            }
            
            CircularProgressView(progress: store.progress)
                .frame(width: 100, height: 100)
                .font(.title2)
                .padding(8)
                .background {
                    Circle()
                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                }
        }
        .animation(.smooth, value: store.currentStates.last != .start)
        .frame(maxWidth: .infinity)
    }
    
}

#Preview {
    OnboardingView(store: .init(initialState: .init(), reducer: {
        OnboardingFeature()
    }))
    .tint(Color.green)
}
