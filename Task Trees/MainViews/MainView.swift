//
//  ContentView.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/15/20.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var adHocStore: AdHocStore
    //    @ObservedObject var alertManager: AlertManager
    
    init(adHocStore: AdHocStore) {
        self.adHocStore = adHocStore
        // sself.alertManager = alertManager
    }
    
    var body: some View {
        GeometryReader {(proxy: GeometryProxy) in
            HStack {
                AdHocToolbar(adHocStore: adHocStore)
                    .padding()
                    .frame(width: proxy.size.width*0.2, height: nil, alignment: .center)
                ZStack {
                    Rectangle()
                        .foregroundColor(.black)
                    //                        .foregroundColor(.init(red: 135.0/255, green: 206.0/255, blue: 250.0/255))
                    if adHocStore.currentlyExamining == nil {
                        FractalTreeView()
                    } else {
                        AdHocManagerView(adHocManager: adHocStore.currentlyExamining!)
                    }
                }
                .frame(width: proxy.size.width*0.6, height: nil, alignment: .center)
                RecurringToolbar(recurringTaskManager: recurringTaskManager)
                .padding()
                .frame(width: proxy.size.width*0.2, height: nil, alignment: .center)
            }
            .background(BlurView())
        }
        //        .sheet(isPresented: $alertManager.isShowingModal, content: {
        //            switch alertManager.modalType {
        //            case .editingAdHocTask:
        //                return AnyView(AdHocEditTaskView())
        //            case .editingRecurringTask:
        //                fatalError()
        //            }
        //        })
        //        .alert(isPresented: $alertManager.isDeletingAdHocTask) {
        //            Alert(title: Text("Delete Task"), message: Text("Remove Task \"\(alertManager.deletingAdHocTask!.name)\""), primaryButton: .destructive(Text("Confirm"), action: {
        //                let toBeDeleted = alertManager.deletingAdHocTask!
        //                toBeDeleted.manager.delete(child: toBeDeleted)
        //            }), secondaryButton: .cancel())
        //        }
    }
}

//struct ContentView: View {
//
//    @State var presentingDeletion = false
//
//    var body: some View {
//        Button("Hello, World!") {presentingDeletion = true}
//            .alert(isPresented: $presentingDeletion, content: {
//                Alert(title: .init(verbatim: "Delete Task"), message: .init(verbatim: "Are you sure you want to delete this task?"), primaryButton: .destructive(.init(verbatim: "Delete"), action: {
//                    print("Deleted")
//                }), secondaryButton: .cancel())
//            })
//    }
//}
