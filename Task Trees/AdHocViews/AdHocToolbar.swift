//
//  AdHocToolbar.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/17/20.
//

import SwiftUI

struct AdHocToolbar: View {
    
    @ObservedObject var adHocStore: AdHocStore
    
    @State var presentingTask: AdHocTask? = nil
    
    init(adHocStore: AdHocStore) {
        self.adHocStore = adHocStore
    }
    
    //    func generateRemoveAdHocManagerAlert(from: AdHocManager) -> Alert {
    //        Alert(title: Text("Delete Root Task"), message: Text("Do you want to delete root task \"\(from.root.name)?\""), primaryButton: .destructive(Text("Confirm"), action: {adHocStore.remove(manager: from)}), secondaryButton: .cancel())
    //    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Ad Hoc Tasks")
                    .font(.headline)
                Spacer()
                Button("Add New") {
                    adHocStore.addNew()
                    presentingTask = adHocStore.store.last!.root
                }
                .sheet(item: $presentingTask, content: {(task: AdHocTask) in
                    AdHocEditTaskView(adHocTask: task, unpresentView: {presentingTask = nil})
                })
            }
            .padding()
            List(adHocStore.store) {(adHocManager: AdHocManager) in
                AdHocToolBarManagerUtilityView(adHocManager: adHocManager, adHocStore: adHocStore)
            }
            ScrollView(.vertical) {
                VStack {
                    ForEach(0..<8, content: {(daysFromNow: Int) in
                        AdHocToolBarDayCompletionContainerView(leafContainer: adHocStore.dayLeaves[daysFromNow], daysFromNow: daysFromNow)
                            .padding(5)
                    })
                }
            }
        }
        // .background(BlurView())
    }
}

struct AdHocToolBarDayCompletionContainerView: View {
    
    @ObservedObject var leafContainer: AdHocStore.DayLeafContainer
    let daysFromNow: Int
    
    var body: some View {
        VStack {
            Text(DateCalculator.getPrettyString(fromDayDelta: daysFromNow).capitalized(with: nil))
                .font(.headline)
                .italic()
                .padding(5.0)
            VStack {
                ForEach(leafContainer.leavesDue) {(adHocTask: AdHocTask) in
                    VStack {
                        Divider()
                        AdHocToolBarDayCompletionView(adHocTask: adHocTask)
                            .padding(5)
                    }
                }
            }
        }
        .centered()
        .background(RoundedRectangle(cornerRadius: 10.0).stroke().foregroundColor(.white))
    }
    
}

struct AdHocToolBarDayCompletionView: View {
    
    @ObservedObject var adHocTask: AdHocTask
    
    @State var completingManager: AdHocManager? = nil
    
    // @State var completingAdHocTask: AdHocTask?
    
    var body: some View {
        HStack {
            Text(adHocTask.name)
            Spacer()
            
            Button("View") {
                adHocStore.currentlyExamining = adHocTask.manager
            }
            Button("Complete") {
                if adHocTask.isRoot() {
                    completingManager = adHocTask.manager
                } else {
                    adHocTask.manager.complete(leaf: adHocTask)
                }
            }
            .foregroundColor(.blue)
            .alert(item: $completingManager, content: {(aht: AdHocManager) in Alert(title: Text("Delete Root Task"), message: Text("Do you want to complete root task \"\(aht.root.name)\"?"), primaryButton: .destructive(Text("Confirm"), action: {
                adHocStore.remove(manager: aht)
                adHocStore.refreshLeavesDue(daysFromNow: adHocTask.completeBy - dateCalculator.today)
                if adHocStore.currentlyExamining == aht {
                    adHocStore.currentlyExamining = nil
                }
            }), secondaryButton: .cancel())})
            
        }
        .padding(.horizontal)
    }
}

struct AdHocToolBarManagerUtilityView: View {
    
    @ObservedObject var adHocManager: AdHocManager
    @State var removingAdHocManager: AdHocManager? = nil
    @ObservedObject var adHocStore: AdHocStore
    
    var body: some View {
        VStack {
            AdHocToolBarUtilityView(root: adHocManager.root)
                .padding(.horizontal, nil)
            HStack {
                if adHocStore.currentlyExamining == adHocManager {
                    Button("Unselect") {
                        adHocStore.currentlyExamining = nil
                    }
                } else {
                    Button("Select") {
                        adHocStore.currentlyExamining = adHocManager
                    }
                }
                
                Button("Delete") {
                    removingAdHocManager = adHocManager
                }
                .foregroundColor(.red)
                
                .alert(item: $removingAdHocManager, content: {(aht: AdHocManager) in Alert(title: Text("Delete Root Task"), message: Text("Do you want to delete root task \"\(aht.root.name)\"?"), primaryButton: .destructive(Text("Confirm"), action: {
                    adHocStore.remove(manager: aht)
                    if adHocStore.currentlyExamining == aht {adHocStore.currentlyExamining = nil}
                }), secondaryButton: .cancel())})
            }
            Divider()
        }
        //.padding(.horizontal, nil)
    }
}

struct AdHocToolBarUtilityView: View {
    
    @ObservedObject var root: AdHocTask
    
    var body: some View {
        Text(root.name)
    }
}

//struct AdHocToolbar_Previews: PreviewProvider {
//    static var previews: some View {
//        AdHocToolbar()
//    }
//}
