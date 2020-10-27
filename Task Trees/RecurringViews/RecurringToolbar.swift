//
//  RecurringToolbar.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/24/20.
//

import SwiftUI

struct RecurringToolbar: View {
    
    @ObservedObject var recurringTaskManager: RecurringTaskManager
    
    @State var presentingTask: RecurringTask? = nil
    
    var body: some View {
        VStack {
            HStack {
                Text("Recurring Tasks")
                    .font(.headline)
                Spacer()
                Button("Add New", action: {
                    recurringTaskManager.addNew()
                    presentingTask = recurringTaskManager.inactive.last!
                })
            }
            .padding()
            // TO DO
            VStack {
                Text("To Do")
                    .font(.headline)
                    .italic()
                    .padding(5.0)
                ForEach(recurringTaskManager.todo) {(recurringTask: RecurringTask) in
                    VStack {
                        Divider()
                        HStack {
                            Text(recurringTask.name)
                            Spacer()
                            Button("Done") {
                                recurringTaskManager.complete(recurringTask: recurringTask)
                            }
                            Button("Edit") {
                                presentingTask = recurringTask
                            }
                        }
                        .padding(5.0)
                    }
                }
            }
            .centered()
            .background(RoundedRectangle(cornerRadius: 10.0).stroke().foregroundColor(.white))
            Divider()
            VStack {
                Text("Done")
                    .font(.headline)
                    .italic()
                    .padding(5.0)
                ForEach(recurringTaskManager.done) {(recurringTask: RecurringTask) in
                    VStack {
                        Divider()
                        HStack {
                            Text(recurringTask.name)
                            Spacer()
                            Button("Undo") {
                                recurringTaskManager.uncomplete(recurringTask: recurringTask)
                            }
                            Button("Edit") {
                                presentingTask = recurringTask
                            }
                        }
                        .padding(5.0)
                    }
                }
            }
            .centered()
            .background(RoundedRectangle(cornerRadius: 10.0).stroke().foregroundColor(.white))
            Divider()
            Spacer()
            Divider()
            // REST OF PLANS
            VStack {
                Text("Inactive")
                    .font(.headline)
                    .italic()
                    .padding(5.0)
                ForEach(recurringTaskManager.inactive) {(recurringTask: RecurringTask) in
                    VStack {
                        Divider()
                        HStack {
                            Text(recurringTask.name)
                            Spacer()
                            Button("Edit") {
                                presentingTask = recurringTask
                            }
                        }
                        .padding(5.0)
                    }
                }
            }
            .centered()
            .background(RoundedRectangle(cornerRadius: 10.0).stroke().foregroundColor(.white))
        }
        .sheet(item: $presentingTask, content: {(task: RecurringTask) in
            RecurringEditTaskView(recurringTask: task, unpresentView: {presentingTask = nil})
        })
    }
}
