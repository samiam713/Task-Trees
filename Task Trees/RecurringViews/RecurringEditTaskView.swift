//
//  RecurringEditTaskView.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/24/20.
//

import SwiftUI

let dayDescriptions = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]

struct RecurringEditTaskView: View {
    
    @ObservedObject var recurringTask: RecurringTask
    let unpresentView: () -> ()
    
    @State var deletionAlert = false
    
    var body: some View {
        Form {
            Section {
                TextField("Description", text: $recurringTask.name)
                    .padding()
            }
            Divider()
            Section {
                Text("Today is \(recurringTask.days.count == 7 ? dayDescriptions[dateCalculator.today % recurringTask.days.count] : "day \(dateCalculator.today % recurringTask.days.count)/\(recurringTask.days.count)")")
                    .italic()
                    .padding()
                    .centered()
                CycleEditorView(recurringTask: recurringTask)
                    .padding()
                ZStack {
                    HStack {
                        if recurringTask.canDecreaseCycleSize() {
                            Button("Decrease Cycle Size",action: recurringTask.decreaseCycleSize)
                        }
                        Spacer()
                        if recurringTask.canIncreaseCycleSize() {
                            Button("Increase Cycle Size",action: recurringTask.increaseCycleSize)
                        }
                    }
                    Text(recurringTask.cycleSizeDescription())
                        .centered()
                }
                .padding()
            }
            Divider()
            Section {
                Button("Done Editing", action: unpresentView)
                    .padding(5.0)
                    .centered()
                Button("Delete") {
                    deletionAlert = true
                }
                .padding(5.0)
                .centered()
                .foregroundColor(.red)
                .alert(isPresented: $deletionAlert, content: {
                    Alert(title: Text("Delete Task"), message: Text("Do you want to delete recurring task \"\(recurringTask.name)?\""), primaryButton: .destructive(Text("Confirm"), action: {
                        unpresentView()
                        recurringTaskManager.delete(recurringTask: recurringTask)
                    }), secondaryButton: .cancel())
                })
            }
        }
        .frame(width: 700, height: 500, alignment: .center)
    }
}

struct CycleEditorView: View {
    
    @ObservedObject var recurringTask: RecurringTask
    
    var body: some View {
        GeometryReader {(proxy: GeometryProxy) in
            HStack {
                ForEach(recurringTask.days) {(idBool: IDBool) in
                    VStack{
                        ZStack {
                            if dateCalculator.today % recurringTask.days.count == idBool.day {
                                Circle()
                                    .stroke(lineWidth: 5.0)
                                    .foregroundColor(.black)
                            }
                            IDBoolToggler(idBool: idBool)
                        }
                        .frame(width: proxy.size.width/8.0, height: proxy.size.width/8.0, alignment: .center)
                        Text(recurringTask.days.count == 7 ? dayDescriptions[idBool.day] : "Day \(idBool.day)")
                    }
                    .frame(width: proxy.size.width/8.0, alignment: .center)
                }
                Spacer()
            }
            .frame(width: proxy.size.width, height: nil, alignment: .center)
        }
    }
}
