//
//  ContentView.swift
//  MyTripEra
//
//  Created by Ria Garg on 1/23/24.
//

import SwiftUI
import SwiftData
import MapKit
import CoreLocation
let oR = Color(red: 0.92, green: 0.40, blue: 0.35)
let defaults = UserDefaults.standard

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var isAddingItem = false
    @State private var isSendingQuestion = false
    @State private var isShowingInstructions: Bool
    @State var isCreatingTrip = false
    @State private var question = ""
    
    init() {
        // Check if isShowingInstructions has been set in UserDefaults
        if UserDefaults.standard.bool(forKey: "isShowingInstructions") {
            _isShowingInstructions = State(initialValue: false)
        } else {
            _isShowingInstructions = State(initialValue: true)
            UserDefaults.standard.set(true, forKey: "isShowingInstructions")
        }
    }

    
    var body: some View {
        NavigationSplitView {
            List {
                Section(header: Text("Trips").font(.headline).foregroundColor(oR)) {
                    ForEach(items) { item in
                        NavigationLink {
                            TripDetailsView(curItem: item, tripType: item.type, tripName: item.name, addItem: addItem)
                        } label: {
                            HStack {
                                Text(item.name)
                                    .font(.title2)
                                Spacer()
                                Text(item.type)
                                    .font(.subheadline)
                                    .opacity(0.6)
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: PlannerView()) {
                            Image(systemName: "lightbulb")
                                .foregroundColor(oR)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .font(.title2)
                        .foregroundColor(oR)
                }
                ToolbarItem {
                    Button(action: {isAddingItem = true}) {
                        Image(systemName: "plus")
                            .foregroundColor(oR)
                    }
                }
            }
            HStack {
                TextEditor(text: $question)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 10) // Add horizontal padding
                    .frame(height: 38)
                    .overlay(
                            RoundedRectangle(cornerRadius: 5) // Adjust the corner radius as needed
                                .stroke(oR, lineWidth: 2) // Set your desired color and line width
                    )
                    .padding(.top, 11)
                    .padding(.bottom, 7)

                
                Button(action: {
                    isSendingQuestion = true
                }) {
                    Text("Send")
                        .font(.title2)
                        .foregroundColor(oR)
                }
                .padding(.vertical, 10)
            }
            .padding(.horizontal, 20)
        } detail: {
            Text("Select an item")
        }
        .sheet(isPresented: $isShowingInstructions) {
            InstructionsView()
            Button(action: {
                isShowingInstructions = false
                UserDefaults.standard.set(false, forKey: "isShowingInstructions")
                question = ""
            }) {
                Text("Get started")
                    .font(.title2)
                    .foregroundColor(oR)
            }
        }
        
        .sheet(isPresented: $isAddingItem) {
            TripCreationView(
                isCreatingTrip: $isAddingItem,
                addItem: addItem(newName:newType:)
            )
        }
        .sheet(isPresented: $isSendingQuestion) {
            APIAnswerView(
                question: $question,
                items: items
            )
            Button(action: {
                isSendingQuestion = false
                question = ""
            }) {
                Text("Got it!")
                    .font(.title2)
                    .foregroundColor(oR)
            }
        }
    }
    private func addItem(newName: String, newType: String) {
        withAnimation {
            let newItem = Item(name: newName, type: newType, allInputs: [])
            modelContext.insert(newItem)
        }
        
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
