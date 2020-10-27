//
//  RecurringTaskManager.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/24/20.
//

import Foundation

fileprivate let recurringTaskManagerURL = fileSystem.urlFromString("RecurringTaskManager")

let recurringTaskManager = fileSystem.fileExists(at: recurringTaskManagerURL) ? fileSystem.load(this: RecurringTaskManager.self, from: recurringTaskManagerURL) : RecurringTaskManager()

class RecurringTaskManager: ObservableObject, Codable {
    
    var lastDayUpdated: Int
    
    @Published var todo: [RecurringTask]
    @Published var done: [RecurringTask]
    @Published var inactive: [RecurringTask]
    
    @Published var currentlyEditing: RecurringTask? = nil
    
    init() {
        lastDayUpdated = dateCalculator.today
        
        todo = []
        done = []
        inactive = []
        
    }
    
    func refreshIfNecessary() {
        if lastDayUpdated != dateCalculator.today {
            
            lastDayUpdated = dateCalculator.today
            
            var newTodo = [RecurringTask]()
            var newInactive = [RecurringTask]()
            
            func classifyTask(recurringTask: RecurringTask) {
                if recurringTask.appliesTo(day: lastDayUpdated) {
                    newTodo.append(recurringTask)
                } else {
                    newInactive.append(recurringTask)
                }
            }
            
            for task in todo {classifyTask(recurringTask: task)}
            
            for task in done {classifyTask(recurringTask: task)}
            
            for task in inactive {classifyTask(recurringTask: task)}
            
            todo = newTodo
            done = []
            inactive = newInactive
        }
    }

    func complete(recurringTask: RecurringTask) {
        todo.unsafeRemove(element: recurringTask)
        done.append(recurringTask)
    }
    
    func uncomplete(recurringTask: RecurringTask) {
        done.unsafeRemove(element: recurringTask)
        todo.append(recurringTask)
    }

    func delete(recurringTask: RecurringTask) {
        if todo.contains(recurringTask) {
            todo.unsafeRemove(element: recurringTask)
        } else if done.contains(recurringTask) {
            done.unsafeRemove(element: recurringTask)
        } else if inactive.contains(recurringTask) {
            inactive.unsafeRemove(element: recurringTask)
        }
    }
    
    func toggle(recurringTask: RecurringTask, onDay: Int) {
        let wasActive = recurringTask.days[onDay].bool
        defer {recurringTask.days[onDay].toggle()}
        
        if onDay == dateCalculator.today % recurringTask.days.count {
            if wasActive {
                if todo.contains(recurringTask) {
                    todo.unsafeRemove(element: recurringTask)
                    inactive.append(recurringTask)
                } else if done.contains(recurringTask) {
                    done.unsafeRemove(element: recurringTask)
                    inactive.append(recurringTask)
                } else {
                    fatalError()
                }
            } else {
                inactive.unsafeRemove(element: recurringTask)
                todo.append(recurringTask)
            }
        }
    }

    func addNew() {
        let newRecurringTask = RecurringTask()
        inactive.append(newRecurringTask)
        currentlyEditing = newRecurringTask
    }
    
    enum Key: String, CodingKey {
        case todo, done, inactive, lastDayUpdated
    }
    
    func save() {
        fileSystem.save(this: self, to: recurringTaskManagerURL)
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        todo = try container.decode([RecurringTask].self, forKey: .todo)
        done = try container.decode([RecurringTask].self, forKey: .done)
        inactive = try container.decode([RecurringTask].self, forKey: .inactive)
        lastDayUpdated = try container.decode(Int.self, forKey: .lastDayUpdated)
        refreshIfNecessary()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(todo, forKey: .todo)
        try container.encode(done, forKey: .done)
        try container.encode(inactive, forKey: .inactive)
        try container.encode(lastDayUpdated, forKey: .lastDayUpdated)
    }
}
