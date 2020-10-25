//
//  IDBoolToggler.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/24/20.
//

import SwiftUI

struct IDBoolToggler: View {
    
    @ObservedObject var idBool: IDBool

    let sqrtOfOneHalf: CGFloat = 0.70710678118654757

    var body: some View {
        Button(action: idBool.toggle, label: {
            GeometryReader {(proxy: GeometryProxy) in
                ZStack {
                    Circle()
                        .foregroundColor(idBool.bool ? .green : .red)
                    if idBool.bool {
                        CheckShape()
                            .foregroundColor(.gray)
                            .frame(width: sqrtOfOneHalf*min(proxy.size.width,proxy.size.height), height: sqrtOfOneHalf*min(proxy.size.width,proxy.size.height), alignment: .center)
                    } else {
                        XShape()
                            .foregroundColor(.gray)
                            .frame(width: sqrtOfOneHalf*min(proxy.size.width,proxy.size.height), height: sqrtOfOneHalf*min(proxy.size.width,proxy.size.height), alignment: .center)
                    }
                }

            }
            .buttonStyle(PlainButtonStyle())
        })
    }
}

struct CheckShape: Shape {
    func path(in rect: CGRect) -> Path {
        let h = rect.size.height
        let w = rect.size.width

        let lines: [CGPoint] = [
            CGPoint(x: 0.1*w, y: 0.5*h),
            CGPoint(x: 0.1*w, y: 0.7*h),
            CGPoint(x: 0.3*w, y: 0.9*h),
            CGPoint(x: 0.9*w, y: 0.3*h),
            CGPoint(x: 0.8*w, y: 0.2*h),
            CGPoint(x: 0.3*w, y: 0.7*h),
        ]
        
        return Path {(path: inout Path) in
            path.addSubpath(lines: lines)
        }
    }
}

struct XShape: Shape {
    func path(in rect: CGRect) -> Path {
        let h = rect.size.height
        let w = rect.size.width

        let lines: [CGPoint] = [
            CGPoint(x: 0.1*w, y: 0.2*h),
            CGPoint(x: 0.4*w, y: 0.5*h),
            CGPoint(x: 0.1*w, y: 0.8*h),
            CGPoint(x: 0.2*w, y: 0.9*h),
            CGPoint(x: 0.5*w, y: 0.6*h),
            CGPoint(x: 0.8*w, y: 0.9*h),
            CGPoint(x: 0.9*w, y: 0.8*h),
            CGPoint(x: 0.6*w, y: 0.5*h),
            CGPoint(x: 0.9*w, y: 0.2*h),
            CGPoint(x: 0.8*w, y: 0.1*h),
            CGPoint(x: 0.5*w, y: 0.4*h),
            CGPoint(x: 0.2*w, y: 0.1*h),
        ]
        
        return Path {(path: inout Path) in
            path.addSubpath(lines: lines)
        }
    }
}

struct IDBoolToggler_Previews: PreviewProvider {
    static var previews: some View {
        IDBoolToggler(idBool: .init())
    }
}
