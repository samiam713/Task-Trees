//
//  Utilities.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/15/20.
//

import Foundation
import SwiftUI

extension Date {
    
    // try! fileSystem.decoder.decode(TimeZone.self, from: "{\"identifier\":\"America\\/Los_Angeles\"}".data(using: .utf8)!)
    
    static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "MMMM dd, yyyy"
        formatter.timeZone = .current
        return formatter
    }()
    
    func toShortDate() -> String {
        Self.formatter.string(from: self)
    }
}

extension Array where Element: Equatable {
    mutating func unsafeRemove(element: Element) {
        self.remove(at: self.firstIndex(of: element)!)
    }
}

extension View {
    func centered() -> some View {
        return HStack {
            Spacer()
            self
            Spacer()
        }
    }
}

extension Path {
    mutating func addSubpath(lines: [CGPoint]) {
        move(to: lines.last!)
        addLines(lines)
        closeSubpath()
    }
}
