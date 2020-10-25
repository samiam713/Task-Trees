//
//  IDBool.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/24/20.
//

import Foundation

class IDBool: Identifiable, ObservableObject, Codable {
    @Published var bool: Bool
    
    init() {
        self.bool = false
    }
    
    func toggle() {
        bool.toggle()
    }
    
    enum Key: String, CodingKey {
        case bool
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        bool = try container.decode(Bool.self, forKey: .bool)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(bool, forKey: .bool)
    }
}
