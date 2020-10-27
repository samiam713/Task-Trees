//
//  AdHocStore.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/15/20.
//

import Foundation

fileprivate let adHocStoreURL = fileSystem.urlFromString("AdHocStore")

let adHocStore = fileSystem.fileExists(at: adHocStoreURL) ? fileSystem.load(this: AdHocStore.self, from: adHocStoreURL) : AdHocStore()

class AdHocStore: Codable, ObservableObject {
    
    @Published var currentlyExamining: AdHocManager?
    @Published var store: [AdHocManager]
    
    init() {
        store = []
        currentlyExamining = nil
        
        dayLeaves = [DayLeafContainer]()
        dayLeaves.reserveCapacity(8)
        
        for _ in 0..<8 {
            dayLeaves.append(.init())
        }
    }
    
    func save() {
        fileSystem.save(this: self, to: adHocStoreURL)
    }
    
    class DayLeafContainer: ObservableObject {
        @Published var leavesDue = [AdHocTask]()
    }
    
    var dayLeaves: [DayLeafContainer]
    // change below to "refresh" and run in two species of cases:
    
    // Species 1:
    // - refresh all the leaves at app launch. avoids bug of == but not ===
    
    // Species 2:
    // - refresh the leaves due on day N when you change whether or not a day N leaf is usingDate
    // - refresh in any case a leaf that is usingDate enters or exits manager.leafNodes
    
    func refreshLeavesDue(daysFromNow: Int) {
        print("Calling on \(daysFromNow)")
        guard (0...7).contains(daysFromNow) else {return}
        
        var gatherer = [AdHocTask]()
        
        let dueDate = dateCalculator.today + daysFromNow
        
        for manager in store {
            for leafNode in manager.leafNodes {
                if leafNode.usingCompleteBy && leafNode.completeBy == dueDate {
                    gatherer.append(leafNode)
                }
            }
        }
        
        print(gatherer.count)
        
        dayLeaves[daysFromNow].leavesDue = gatherer
        // dayLeaves[daysFromNow].objectWillChange.send()
        print(dayLeaves[daysFromNow])
    }
    
    func addNew() {
        let newTree = AdHocManager()
        adHocStore.currentlyExamining = newTree
        store.append(newTree)
    }
    
    func remove(manager: AdHocManager) {
        store.unsafeRemove(element: manager)
        for i in 0..<8 {
            refreshLeavesDue(daysFromNow: i)
        }
    }
    
    enum Key: String, CodingKey {
        case store
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        store = try container.decode([AdHocManager].self, forKey: .store)
        currentlyExamining = nil
        
        dayLeaves = []
        dayLeaves.reserveCapacity(8)
        
        for i in 0...7 {
            dayLeaves.append(.init())
            refreshLeavesDue(daysFromNow: i)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(store, forKey: .store)
    }
}
