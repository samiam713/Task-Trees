//
//  TreeFractal.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/16/20.
//

import SwiftUI

fileprivate let opposite: CGFloat = 0.3
fileprivate let adjacent: CGFloat =  0.5

fileprivate let rotationAngle: CGFloat = atan(opposite/adjacent)
fileprivate let negativeRotationAngle = -rotationAngle
fileprivate let negativeNinetyDegrees = CGFloat.pi*0.5

fileprivate let scaleFactor: CGFloat = sqrt(opposite*opposite+adjacent*adjacent)

extension CGPoint {
    
    func scaled(by: CGFloat) -> CGPoint {
        return .init(x: x*by, y: y*by)
    }
    
    func add(_ other: CGPoint) -> CGPoint {
        return .init(x: x + other.x, y: y + other.y)
    }
    
    func rotate(radians: CGFloat) -> CGPoint {
        return .init(x: cos(radians)*x - sin(radians)*y,
                     y: sin(radians)*x + cos(radians)*y)
    }
}

fileprivate func drawTree(path: inout Path, startPoint: CGPoint, directionVector: CGPoint, subTrees: Int) -> CGPoint {
    // RETURNS END POINT
    
    let dV2 = directionVector.rotate(radians: negativeNinetyDegrees).scaled(by: 0.25)
    
    let firstStop = startPoint.add(directionVector)
    let finalDestination = startPoint.add(dV2)
    
    // draw to firstStop
    path.addLine(to: firstStop)
    
    if subTrees <= 0 {
        // if subTrees == 0 draw toSecondStop
        let secondStop = firstStop.add(dV2)
        path.addLine(to: secondStop)
    } else {
        // else draw toSecondStop using recursion
        let scaled = directionVector.scaled(by: scaleFactor)
        let firstDV = scaled.rotate(radians: negativeRotationAngle)
        let secondDV = scaled.rotate(radians: rotationAngle)
        
        let halfWayPoint = drawTree(path: &path, startPoint: firstStop, directionVector: firstDV, subTrees: subTrees-1)
        _ = drawTree(path: &path, startPoint: halfWayPoint, directionVector: secondDV, subTrees: subTrees-1)
    }
    
    // draw to final stop
    path.addLine(to: finalDestination)
    return finalDestination
}

fileprivate struct FractalTree: Shape {
    
    let subtrees: Int
    
    func path(in rect: CGRect) -> Path {
        return Path {(path: inout Path) in
            guard rect.origin == CGPoint(x: 0, y: 0) else {fatalError()}
            
            let xMagnitude = rect.maxX*0.07
            
            let startPoint = CGPoint(x: rect.midX - xMagnitude/2.0, y: rect.maxY - 5.0)
            
            let directionVector = CGPoint(x: 0.0, y: -xMagnitude*4.0)
            
            path.move(to: startPoint)
            let _ = drawTree(path: &path, startPoint: startPoint, directionVector: directionVector, subTrees: subtrees)
            
            path.addLine(to: startPoint)
            
            path.closeSubpath()
            
            
            
        }
    }
}

struct FractalGrass: Shape {
    func path(in rect: CGRect) -> Path {
        let lines = [
            CGPoint(x: rect.maxX, y: rect.maxY - 6.0),
            CGPoint(x: rect.minX, y: rect.maxY - 6.0),
            CGPoint(x: rect.minX, y: rect.maxY),
            CGPoint(x: rect.maxX, y: rect.maxY)
        ]
        
        return Path {
            $0.addLines(lines)
        }
    }
}

struct FractalTreeView: View {
    
    @State var subtrees = 6
    @State var offset: CGFloat = 0.0
    
    let max = 10
    
    var body: some View {
        VStack {
            ZStack {
                Image("TaskTreesTitle")
                    .resizable()
                    .scaledToFit()
                    .offset(x: 0.0, y: -160.0+offset)
                    .animation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true))
                // the circle is a stand in for an image
                FractalTree(subtrees: subtrees)
                    .foregroundColor(.brown)
                FractalGrass()
                    .foregroundColor(.init(red: 0.0, green: 100.0/255, blue: 0.0))
                //                FractalTree(subtrees: subtrees)
                //                    .stroke(lineWidth: 1.0)
                //                    .foregroundColor(.brown)
            }
            ZStack {
                HStack {
                    Text("Day \(dateCalculator.today)")
                        .italic()
                        .font(.subheadline)
                    Spacer()
                    Text(dateCalculator.todayPrettyString)
                        .italic()
                        .font(.subheadline)
                }
                VStack {
                    Stepper("Change number of branches", value: $subtrees, in: 0...max)
                    Text("\((1 << (subtrees+1))-1) branch\(subtrees == 0 ? "" : "es")\(subtrees == 0 ? " (MIN)" : "")\(subtrees == max ? " (MAX)" : "")")
                }
                
            }
            .padding()
            .foregroundColor(.white)
            //            Stepper("Change Branches", onIncrement: {
            //                if subtrees < 10 {subtrees += 1}
            //            }, onDecrement: {
            //                if subtrees > 5 {
            //                    subtrees -= 1
            //                    print(subtrees)
            //                }
            //            })
            //            .foregroundColor(.black)
        }
        .onAppear {
            offset = 40.0
        }
    }
}
