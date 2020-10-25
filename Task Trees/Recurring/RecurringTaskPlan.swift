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
    
    @Published var days: [IDBool]
    let maxCycleSize = 7
    
    init() {
        id = UUID()
        
        days = [.init(),.init()]
    }
    
    func canIncreaseCycleSize() -> Bool {days.count < maxCycleSize}
    func increaseCycleSize() {
        guard canIncreaseCycleSize() else {fatalError()}
        days.append(.init())
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
    
    required init(from decoder: Decoder) throws {
        fatalError()
    }
    
    func encode(to encoder: Encoder) throws {
        fatalError()
    }
}
