//
//  RecurringToolbar.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/24/20.
//

import SwiftUI

//struct RecurringToolbar: View {
//
//    @ObservedObject var recurringTaskManager: RecurringTaskManager
//
//    @State var presentingTask: RecurringTaskPlan? = nil
//
//    var body: some View {
//        VStack {
//            HStack {
//                Text("Ad Hoc Tasks")
//                    .font(.headline)
//                Spacer()
//                Button("New Recurring Task") {
//                   
//                }
//                .sheet(item: $presentingTask, content: {(task: AdHocTask) in
//                    AdHocEditTaskView(adHocTask: task, unpresentView: {presentingTask = nil})
//                })
//            }
//            // TO DO
//            List(adHocStore.store) {(adHocManager: AdHocManager) in
//                AdHocToolBarManagerUtilityView(adHocManager: adHocManager)
//            }
//            // COMPLETED
//
//            // SPACER
//
//            // REST OF PLANS
//        }
//    }
//}
