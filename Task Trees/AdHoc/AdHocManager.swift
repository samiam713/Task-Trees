//
//  AdHocManager.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/15/20.
//

import Foundation
import SwiftUI

class AdHocManager: Identifiable, ObservableObject, Hashable, Codable {
    static func == (lhs: AdHocManager, rhs: AdHocManager) -> Bool {lhs.id == rhs.id}
    func hash(into hasher: inout Hasher) {hasher.combine(id)}
    
    let id: UUID
    
    var depthStride: Double
    var depthPadding: Double
    func setDepthStride(to: Double) {
        depthStride = to
        depthPadding = to*0.5
    }
    
    var widthStride: Double
    var widthPadding: Double
    func setWidthStride(to: Double) {
        widthStride = to
        widthPadding = to*0.5
    }
    
    var leafNodes = [AdHocTask]()
    // DO NOT ENCODE THESE BECAUSE THEY WILL BE DIFFERENT INSTANCES THAN THEY SHOULD BE
    
    var root: AdHocTask!
    
    init() {
        id = UUID()
        
        depthStride = 1.0
        depthPadding = 0.5
        
        widthStride = 1.0
        widthPadding = 0.5
        
        
        root = .init(parent: nil, manager: self)
        leafNodes = [root]
    }
    
    func getChildren() -> [AdHocTask] {
        var children = [AdHocTask]()
        root.collectChildren(into: &children)
        return children
    }
    
    func calculateDrawData() {
        var widthBound = 0.0
        let depthBound = root.updateRecursively(maxWidth: &widthBound, depth: 0.0)
        
        setWidthStride(to: 1/widthBound)
        setDepthStride(to: 1/depthBound)
    }
    
    func addChild(to: AdHocTask) {
        defer {redraw()}
                
        if to.isLeaf() {
            leafNodes.unsafeRemove(element: to)
            if to.usingCompleteBy {adHocStore.refreshLeavesDue(daysFromNow: to.completeBy - dateCalculator.today)}
        }
        
        let newTask = AdHocTask(parent: to, manager: self)
        to.children.append(newTask)
        
        leafNodes.append(newTask)
        if newTask.usingCompleteBy {adHocStore.refreshLeavesDue(daysFromNow: newTask.completeBy - dateCalculator.today)}
    }
    
    func complete(leaf: AdHocTask) {
        // child must be deletable and leaf node
        defer {redraw()}
        
        guard let parent = leaf.parent else {fatalError("Calling complete on the root")}
        parent.children.unsafeRemove(element: leaf)
        if parent.isLeaf() {
            leafNodes.append(parent)
            if parent.usingCompleteBy {adHocStore.refreshLeavesDue(daysFromNow: parent.completeBy - dateCalculator.today)}
        }
        
        leafNodes.unsafeRemove(element: leaf)
        if leaf.usingCompleteBy {adHocStore.refreshLeavesDue(daysFromNow: leaf.completeBy - dateCalculator.today)}
        
    }
    
    func delete(child: AdHocTask) {
        // child must be deletable (not root)
        
        defer {redraw()}
        
        guard let parent = child.parent else {fatalError("Calling complete on the root")}
        
        var leafNodes2 = [AdHocTask]()
        child.collectLeafNodes(into: &leafNodes2)
        
        for leafNode in leafNodes2 {
            leafNodes2.unsafeRemove(element: leafNode)
            if leafNode.usingCompleteBy {adHocStore.refreshLeavesDue(daysFromNow: leafNode.completeBy - dateCalculator.today)}
        }
        
        parent.children.unsafeRemove(element: child)
        if parent.isLeaf() {
            leafNodes.append(parent)
            if parent.usingCompleteBy {adHocStore.refreshLeavesDue(daysFromNow: parent.completeBy - dateCalculator.today)}
        }
        
    }
    
    func redraw() {
        calculateDrawData()
        objectWillChange.send()
    }
    
    enum Key: String, CodingKey {
        case id, depthStride, depthPadding, widthStride, widthPadding, root
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        id = try container.decode(UUID.self, forKey: .id)
        depthStride = try container.decode(Double.self, forKey: .depthStride)
        depthPadding = try container.decode(Double.self, forKey: .depthPadding)
        widthStride = try container.decode(Double.self, forKey: .widthStride)
        widthPadding = try container.decode(Double.self, forKey: .widthPadding)
        root = try container.decode(AdHocTask.self, forKey: .root)
        
        root.recursivelySetManager(manager: self)
        root.collectLeafNodes(into: &leafNodes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(depthStride, forKey: .depthStride)
        try container.encode(depthPadding, forKey: .depthPadding)
        try container.encode(widthStride, forKey: .widthStride)
        try container.encode(widthPadding, forKey: .widthPadding)
        
        try container.encode(root, forKey: .root)
    }
}

