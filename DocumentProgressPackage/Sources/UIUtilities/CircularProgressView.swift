//
//  File.swift
//  
//
//  Created by Hardik Modha on 24/04/24.
//

import Foundation
import SwiftUI

public struct CircularProgressView: View {
    let progress: Double
    let strokeWidth: CGFloat
    
    public init(progress: Double, strokeWidth: CGFloat = 4) {
        self.progress = progress
        self.strokeWidth = strokeWidth
    }
    
    public var body: some View {
        Circle()
            .trim(from: 0, to: progress)
            .stroke(.tint, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
            .fill(Color.clear)
            .rotationEffect(.degrees(-90))
            .overlay {
                Text("\(progress * 100, formatter: .appDefault)%")
                    .contentTransition(.numericText())
            }
            .animation(.smooth, value: progress)
    }
}

#Preview {
    CircularProgressView(progress: 0.35)
        .padding()
}

extension NumberFormatter {
    static var appDefault: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        return formatter
    }()
}

extension String.StringInterpolation {
    mutating func appendInterpolation<T: BinaryFloatingPoint>(_ value: T, formatter: NumberFormatter) {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            appendInterpolation(Int(value))
        } else {
            appendInterpolation(formatter.string(for: value) ?? "\(value)")
        }
    }
}

