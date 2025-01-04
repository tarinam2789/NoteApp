//
//  ContentView.swift
//  Note
//
//  Created by Tarina Afroz Muna on 12/22/24.
//

import SwiftUI

struct ContentView: View {
    @State private var notes: [Note] = [] // List to store Note objects (title + content)
    @State private var newNote: String = "" // Input field for new note title

    var body: some View {
        NavigationView {
            VStack {
                // Input Section for adding new note title
                HStack {
                    TextField("Enter a new note", text: $newNote)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading)

                    Button(action: {
                        // Add new note to the list with empty content
                        if !newNote.isEmpty {
                            let newNoteObject = Note(title: newNote, content: "")
                            notes.append(newNoteObject)
                            newNote = "" // Clear the input field
                        }
                    }) {
                        Text("Add")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                }
                .padding(.vertical)

                // List of Notes
                List {
                    ForEach(notes.indices, id: \.self) { index in
                        NavigationLink(destination: NoteDetailView(note: $notes[index])) {
                            Text(notes[index].title) // Display only the note title
                        }
                    }
                    .onDelete(perform: deleteNote) // Swipe-to-delete functionality
                }
            }
            .navigationTitle("Notes") // Title for the app
            .toolbar {
                EditButton() // Edit mode for deletion
            }
        }
    }

    // Function to delete notes
    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
}

struct NoteDetailView: View {
    @Binding var note: Note // The note (title + content)

    var body: some View {
        VStack(alignment: .leading) {
            // The note title at the top left, without underline
            Text(note.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding([.top, .leading])

            // The editable text field for the note content
            TextEditor(text: $note.content)
                .padding()
                .border(Color.gray, width: 1)
                .frame(minHeight: 300) // Allow the user to write as much as they want
                .keyboardType(.default)
                .lineLimit(nil) // Allow unlimited lines in the TextEditor
                .autocapitalization(.sentences)
                .disableAutocorrection(true)

            Spacer()
        }
        .navigationBarItems(trailing: Button("Save") {
            // Saving happens automatically when user changes text, no need to do anything special
            // as we are directly binding the note's content to the UI and it is updated automatically.
        })
        .onTapGesture {
            // Dismiss the keyboard when tapping outside the text editor
            hideKeyboard()
        }
    }

    // Helper function to dismiss the keyboard when tapped outside the TextEditor
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct Note {
    var title: String
    var content: String
} 
