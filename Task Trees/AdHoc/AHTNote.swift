//
//  AHTNote.swift
//  Task Trees
//
//  Created by Samuel Donovan on 10/17/20.
//

import Foundation
import SwiftUI

struct NoteView: View {
    @ObservedObject var note: Note
    let task: AdHocTask
    
    var body: some View {
        HStack {
            TextField("Edit Note", text: $note.content)
            Button("Delete") {
                task.removeNote(note: note)
            }
        }
    }
}

class Note: Identifiable, ObservableObject, Equatable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        lhs.id == rhs.id
    }
    
    var id = UUID()
    @Published var content = ""
}
