//
//  AdHocTaskView.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/16/20.
//

import SwiftUI

struct AdHocTaskView: View {
    
    @ObservedObject var task: AdHocTask
    
    @State var presentingTask: AdHocTask? = nil
    @State var completingManager: AdHocManager? = nil
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(.white)
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(lineWidth: 3.0)
                .foregroundColor(task.getColor())
            VStack {
                Text(task.name)
                    .font(.headline)
                    .padding()
                if task.usingCompleteBy {
                    Text(dateCalculator.getPrettyString(fromDay: task.completeBy))
                        .font(.subheadline)
                }
                HStack {
                    Button("Edit") {
                        presentingTask = task
                    }
                    .sheet(item: $presentingTask, content: {(task: AdHocTask) in
                        AdHocEditTaskView(adHocTask: task, unpresentView: {presentingTask = nil})
                    })
                    
                    Button("Add Subtask") {
                        task.manager.addChild(to: task)
                    }
                }
                if task.isLeaf() {
                    Button("Complete") {
                        if task.isRoot() {
                            completingManager = task.manager
                        } else {
                            task.manager.complete(leaf: task)
                        }
                    }
                    .foregroundColor(.blue)
                    .alert(item: $completingManager, content: {(aht: AdHocManager) in Alert(title: Text("Delete Root Task"), message: Text("Do you want to complete root task \"\(aht.root.name)\"?"), primaryButton: .destructive(Text("Confirm"), action: {
                        adHocStore.remove(manager: aht)
                        if aht.root.usingCompleteBy {adHocStore.refreshLeavesDue(daysFromNow: aht.root.completeBy - dateCalculator.today)}
                        adHocStore.currentlyExamining = nil
                    }), secondaryButton: .cancel())})
                }
            }
            .foregroundColor(.black)
            .padding()
        }
    }
}

//struct AdHocTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdHocTaskView()
//    }
//}
