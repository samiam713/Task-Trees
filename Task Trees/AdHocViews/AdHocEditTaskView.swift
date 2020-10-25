//
//  AdHocEditTaskView.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/16/20.
//

import SwiftUI

struct AdHocEditTaskView: View {
    
    @ObservedObject var adHocTask: AdHocTask
    
    @State var deletionAlert: AdHocTask? = nil
    
    let unpresentView: () -> ()
    
    init(adHocTask: AdHocTask, unpresentView: @escaping () -> ()) {
        self.adHocTask = adHocTask
        self.unpresentView = unpresentView
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Description", text: $adHocTask.name)
                    .padding()
            }
            Divider()
            Section {
                if adHocTask.usingCompleteBy {
                    HStack {
                        Spacer()
                        Button("Decrease due date") {
                            adHocTask.completeBy -= 1
                            if adHocTask.isLeaf() {
                                adHocStore.refreshLeavesDue(daysFromNow: adHocTask.completeBy - dateCalculator.today)
                                adHocStore.refreshLeavesDue(daysFromNow: adHocTask.completeBy - dateCalculator.today + 1)
                            }
                        }
                        Button("Increase due date") {
                            adHocTask.completeBy += 1
                            if adHocTask.isLeaf() {
                                adHocStore.refreshLeavesDue(daysFromNow: adHocTask.completeBy - dateCalculator.today)
                                adHocStore.refreshLeavesDue(daysFromNow: adHocTask.completeBy - dateCalculator.today - 1)
                            }
                        }
                        Spacer()
                    }
                    Text(dateCalculator.getPrettyString(fromDay: adHocTask.completeBy))
                        .italic()
                        .centered()
                    Button("Stop using due date") {
                        adHocTask.usingCompleteBy = false
                        if adHocTask.isLeaf() {
                            adHocStore.refreshLeavesDue(daysFromNow: adHocTask.completeBy - dateCalculator.today)
                        }
                    }
                    .centered()
                } else {
                    Button("Start using due date") {
                        adHocTask.usingCompleteBy = true
                        if adHocTask.isLeaf() {
                            adHocStore.refreshLeavesDue(daysFromNow: adHocTask.completeBy - dateCalculator.today)
                        }
                    }
                    .centered()
                }
            }
            Divider()
            Section {
                Text("Notes")
                    .bold()
                    .centered()
                
                Button("Add Note", action: adHocTask.addNote)
                    .centered()
                
                List {
                    ForEach(adHocTask.notes) {(note: Note) in
                        NoteView(note: note, task: adHocTask)
                    }
                    
                }
                .padding()
                .centered()
            }
            Divider()
            Section {
                Button("Done Editing", action: unpresentView)
                    .padding(5.0)
                    .centered()
                if !adHocTask.isRoot() {
                    Button("Delete") {
                        deletionAlert = adHocTask
                    }
                    .padding(5.0)
                    .centered()
                    .foregroundColor(.red)
                    .alert(item: $deletionAlert, content: {(task: AdHocTask) in
                        Alert(title: Text("Delete Task"), message: Text("Do you want to delete task \"\(task.name)?\""), primaryButton: .destructive(Text("Confirm"), action: {
                            unpresentView()
                            task.manager.delete(child: task)
                        }), secondaryButton: .cancel())
                    })
                }
            }
        }
        .frame(width: 600, height: 400, alignment: .center)
    }
}

//struct AdHocEditTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdHocEditTaskView()
//    }
//}
