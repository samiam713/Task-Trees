//
//  RecurringTaskPlan.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/24/20.
//

import Foundation

class RecurringTask: ObservableObject, Identifiable, Equatable, Codable {
    
    static func == (lhs: RecurringTask, rhs: RecurringTask) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    
    var name: String = "New Recurring Task"
    
    @Published var days  = [IDBool]()
    let maxCycleSize = 7
    
    init() {
        id = UUID()
        
        days = [.init(task: self, day: 0),.init(task: self, day: 1)]
    }
    
    func canIncreaseCycleSize() -> Bool {days.count < maxCycleSize}
    func increaseCycleSize() {
        guard canIncreaseCycleSize() else {fatalError()}
        days.append(.init(task: self, day: days.count))
    }
    
    func canDecreaseCycleSize() -> Bool {days.count > 1}
    func decreaseCycleSize() {
        guard canDecreaseCycleSize() else {fatalError()}
        _ = days.popLast()
    }
    
    func appliesTo(day: Int) -> Bool {
        return days[day % days.count].bool
    }
    
    func cycleSizeDescription() -> String {
        switch days.count {
        case 1: return "Daily"
        case 2: return "Every other day"
        case 7: return "Weekly"
        default: return "\(days.count)-day Cycle"
        }
    }
    
    enum Key: String, CodingKey {
        case id, name, days
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        days = try container.decode([IDBool].self, forKey: .days)
        days.forEach({$0.task = self})
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(days, forKey: .days)
    }
}
