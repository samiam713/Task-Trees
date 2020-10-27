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

class Note: Identifiable, ObservableObject, Equatable, Codable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    @Published var content: String
    
    init() {
        self.id = UUID()
        self.content = ""
    }
    
    enum Key: String, CodingKey {
        case id, content
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        id = try container.decode(UUID.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(content, forKey: .content)
    }
}
