//
//  AdHocBackground.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/16/20.
//

import SwiftUI
import simd

struct AdHocManagerView: View {
    @ObservedObject var adHocManager: AdHocManager
    
    var body: some View {
        GeometryReader {(proxy: GeometryProxy) in
            ZStack {
                AdHocManagerBackground(proxy: proxy, adHocManager: adHocManager)
                AdHocManagerForeground(proxy: proxy, adHocManager: adHocManager)
            }
        }
    }
}

struct AdHocManagerForeground: View {
    init(proxy: GeometryProxy, adHocManager: AdHocManager) {
        width = proxy.size.width
        depth = proxy.size.height
        
        self.adHocManager = adHocManager
    }
    
    @ObservedObject var adHocManager: AdHocManager
    
    let width: CGFloat
    let depth: CGFloat
    
    let maxWidthProportion: CGFloat = 0.3
    let maxDepthProportion: CGFloat = 0.25
    
    var body: some View {
        ZStack {
            ForEach(adHocManager.getChildren()) {(child: AdHocTask) in
                AdHocTaskView(task: child)
                    .frame(width: width*min(maxWidthProportion,CGFloat(adHocManager.widthStride*0.8)), height: depth*min(0.8*maxDepthProportion,CGFloat(adHocManager.depthStride*0.8)), alignment: .center)
                    .position(x: width*CGFloat(adHocManager.widthPadding + child.breadth*adHocManager.widthStride), y: depth*CGFloat(adHocManager.depthPadding + child.depth*adHocManager.depthStride))
            }
        }
    }
}

struct AdHocManagerBackground: View {
    
    
    // helps to draw the view for an AdHocManager
    let width: CGFloat
    let depth: CGFloat
    
    @ObservedObject var adHocManager: AdHocManager
    
    init(proxy: GeometryProxy, adHocManager: AdHocManager) {
        width = proxy.size.width
        depth = proxy.size.height
        
        self.adHocManager = adHocManager
    }
    
    var body: some View {
        Path {(path: inout Path) in
            for parent in adHocManager.getChildren() {
                if parent.isLeaf() {continue}
                let parentX = width*CGFloat(adHocManager.widthPadding + parent.breadth*adHocManager.widthStride)
                let parentY = depth*CGFloat(adHocManager.depthPadding + parent.depth*adHocManager.depthStride)
                
                for child in parent.children {
                    let childX = width*CGFloat(adHocManager.widthPadding + child.breadth*adHocManager.widthStride)
                    let childY = depth*CGFloat(adHocManager.depthPadding + child.depth*adHocManager.depthStride)
                    
                    let diffVector: SIMD2<Double> = [parent.breadth,parent.depth] - [child.breadth,child.depth]
                    let orthoVector: SIMD2<Double> = [diffVector.y,-diffVector.x]
                    let scaled = 5.0*simd_normalize(orthoVector)
                    
                    let xOffset = CGFloat(scaled.x)
                    let yOffset = CGFloat(scaled.y)
                    
                    let parentMultiplier: CGFloat = 2.5
                    
                    let drawPoints = [CGPoint(x: parentX + parentMultiplier*xOffset, y: parentY + parentMultiplier*yOffset),
                                      CGPoint(x: parentX - parentMultiplier*xOffset, y: parentY - parentMultiplier*yOffset),
                                      CGPoint(x: childX - xOffset, y: childY - yOffset),
                                      CGPoint(x: childX + xOffset, y: childY + yOffset)
                    ]
                    
                    path.move(to: drawPoints.last!)
                    path.addLines(drawPoints)
                    path.closeSubpath()
                }
            }
        }
        .foregroundColor(.gray)
    }
}

//struct AdHocBackground_Previews: PreviewProvider {
//    static var previews: some View {
//        AdHocBackground()
//    }
//}
