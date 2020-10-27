//
//  IDBool.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/24/20.
//

import Foundation

class IDBool: Identifiable, ObservableObject, Codable {
    @Published var bool: Bool
    
    unowned var task: RecurringTask!
    // establish this outside of codable
    
    let day: Int
    
    init(task: RecurringTask, day: Int) {
        self.bool = false
        self.task = task
        self.day = day
    }
    
    func toggle() {
        bool.toggle()
    }
    
    enum Key: String, CodingKey {
        case bool, day
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        bool = try container.decode(Bool.self, forKey: .bool)
        day = try container.decode(Int.self, forKey: .day)
        task = nil
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(bool, forKey: .bool)
        try container.encode(day, forKey: .day)
    }
}
