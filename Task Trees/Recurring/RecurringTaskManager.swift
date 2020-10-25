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
            
            let today = dateCalculator.today
            
            var newTodo = [RecurringTask]()
            var newInactive = [RecurringTask]()
            
            func classifyTask(recurringTask: RecurringTask) {
                if recurringTask.appliesTo(day: today) {
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

    func delete(recurringTaskPlan: RecurringTask) {
        if todo.contains(recurringTaskPlan) {
            todo.unsafeRemove(element: recurringTaskPlan)
        } else if done.contains(recurringTaskPlan) {
            done.unsafeRemove(element: recurringTaskPlan)
        } else if inactive.contains(recurringTaskPlan) {
            inactive.unsafeRemove(element: recurringTaskPlan)
        }
    }

    func addNew() {
        let newRecurringTask = RecurringTask()
        inactive.append(newRecurringTask)
        currentlyEditing = newRecurringTask
    }
    
    required init(from decoder: Decoder) throws {
        fatalError()
    }
    
    func encode(to encoder: Encoder) throws {
        fatalError()
    }
}
