//
//  File.swift
//  
//
//  Created by Hardik Modha on 24/04/24.
//

import Foundation
import SwiftUI

public enum FetchingState<T: Equatable>: Equatable {
    case fetching
    case fetched(T)
    case error(String)
}

extension FetchingState {
    public var isFetching: Bool {
        switch self {
        case .fetching: return true
        default: return false
        }
    }
    
    public var value: T? {
        switch self {
        case .fetched(let value):
            return value
        default:
            return nil
        }
    }
    
    public var error: String? {
        switch self {
        case .error(let string):
            return string
        default:
            return nil
        }
    }
}

public struct FetchingView<T: Equatable, Content: View>: View {
    let title: String?
    let state: FetchingState<T>
    @ViewBuilder var content: (T) -> Content
    
    public init(state: FetchingState<T>, title: String? = nil, @ViewBuilder content: @escaping (T) -> Content) {
        self.title = title
        self.state = state
        self.content = content
    }
    
    public var body: some View {
        switch state {
        case .fetching:
            VStack {
                ProgressView()
                Text("Fetching \(title ?? "")...")
            }
            
        case .fetched(let t):
            content(t)
            
        case .error(let string):
            VStack {
                Image(systemName: "exclamationmark.triangle")
                Text(string)
            }
        }
    }
}
