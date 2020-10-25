//
//  AdHocTask.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/15/20.
//

import Foundation
import SwiftUI

class AdHocTask: Identifiable, Equatable, ObservableObject, Codable {
    
    static func == (lhs: AdHocTask, rhs: AdHocTask) -> Bool {lhs.id == rhs.id}
    
    let id: UUID
    
    @Published var name = "New Task"
    
    @Published var usingCompleteBy = false
    @Published var completeBy = dateCalculator.today + 1
    // use Stepper to manipulate above
    
    unowned var manager: AdHocManager
    // DO NOT ENCODE THE MANAGER
    
    unowned var parent: AdHocTask?
    // DO NOT ENCODE THE PARENT! SET THE PARENT MANUALLY
    
    func isRoot() -> Bool {parent == nil}
    
    @Published var children: [AdHocTask]
    func isLeaf() -> Bool {children.isEmpty}
    
    var depth: Double
    var breadth: Double
    
    init(parent: AdHocTask?, manager: AdHocManager) {
        id = UUID()
        
        self.manager = manager
        self.parent = parent
        
        children = []
        depth = 0.0
        breadth = 0.0
        
        notes = []
    }
    
    func collectChildren(into: inout [AdHocTask]) {
        into.append(self)
        for child in children {
            child.collectChildren(into: &into)
        }
    }
    
    func collectLeafNodes(into: inout [AdHocTask]) {
        if isLeaf() {
            into.append(self)
        } else {
            children.forEach({$0.collectChildren(into: &into)})
        }
    }
    
    func updateRecursively(maxWidth: inout Double, depth: Double) -> Double {
        // after calling this function, maxWidth is updated to the current maxWidth
        // the return value of this function is the height of the tree
        self.depth = depth
        if isLeaf() {
            breadth = maxWidth
            maxWidth += 1
            return 1.0
        } else {
            var maxChildHeight = 1.0
            for child in children {
                let potentialMax = child.updateRecursively(maxWidth: &maxWidth, depth: depth + 1.0)
                if potentialMax > maxChildHeight {maxChildHeight = potentialMax}
            }
            breadth = 0.5*(children.first!.breadth + children.last!.breadth)
            return maxChildHeight + 1
        }
    }
    
    @Published var notes: [Note]
    
    func addNote() {
        notes.append(Note())
    }
    
    func removeNote(note: Note) {
        notes.unsafeRemove(element: note)
    }
    
    func getColor() -> Color {isLeaf() ? .green : .brown}
    
    required init(from decoder: Decoder) throws {
        fatalError()
    }
    
    func encode(to encoder: Encoder) throws {
        fatalError()
    }
}

extension Color {
    static let brown = Self.init(red: 139.0/255.0, green: 69.0/255.0, blue: 19.0/255.0)
}
