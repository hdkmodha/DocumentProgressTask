//
//  File.swift
//  
//
//  Created by Hardik Modha on 24/04/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import PhotosUI

public struct OnboardingSelectPhotoView: View {
    
    @Bindable var store: StoreOf<OnboardingSelectPhotoFeature>
    
    public init(store: StoreOf<OnboardingSelectPhotoFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Button {
                store.isPhotoPickerPresented.toggle()
            } label: {
                if let image = store.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                        .clipShape(.rect(cornerRadius: 12))
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                }
            }
            .photosPicker(isPresented: $store.isPhotoPickerPresented, selection: $store.imageSelection)
            .photosPickerStyle(.presentation)
        }
    }
}

#Preview {
    OnboardingSelectPhotoView(store: .init(initialState: .init(), reducer: {
        OnboardingSelectPhotoFeature()
    }))
}

