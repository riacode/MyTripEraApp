//
//  TripDetailsView.swiftshee
//  MyTripEra
//
//  Created by Ria Garg on 1/26/24.
//

import Foundation
import SwiftUI
import SwiftData
import MapKit
import CoreLocation


struct TripDetailsView: View {
    @Environment(\.modelContext) private var modelContext
    @State var curItem: Item
    @State var tripType: String
    @State var tripName: String
    let addItem: (String, String) -> Void
    @State var input = ""
    @State private var scrollToBottom = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var isUploadingDocument = false
    
    var body: some View {
        VStack() {
            Text(tripName)
                .font(.title)
                .padding(.vertical, 10)
            
            Text(tripType.uppercased())
                .font(.headline)
                .padding(.bottom, 10)
            Divider()
        
            
        ScrollView {
            ScrollViewReader { scrollView in
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(curItem.allInputs, id: \.self) { item in
                        VStack(alignment: .leading) {
                            Text(item)
                                .padding(.bottom, 5) // Adjust padding as needed
                            Divider()
                                .background(Color.gray)
                                .frame(height: 1)
                        }
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 20)
                .onChange(of: scrollToBottom) { newValue, _ in
                    if newValue {
                        withAnimation {
                            scrollView.scrollTo(curItem.allInputs.count - 1, anchor: .bottom)
                            scrollToBottom = false
                        }
                    }
                }
                Spacer()
            }
        }
        .frame(maxHeight: 500 - keyboardHeight)
        
        Spacer()
            
        HStack {
            TextEditor( text: $input)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.top, 8)
                .padding(.bottom, 8)
                .padding(.horizontal, 10) // Add horizontal padding
                .frame(height: 38)
                .overlay(
                        RoundedRectangle(cornerRadius: 5) // Adjust the corner radius as needed
                            .stroke(oR, lineWidth: 2) // Set your desired color and line width
                    )
            
            Button(action: {
                if !input.isEmpty {
                    curItem.allInputs.append(input)
                    input = ""
                    scrollToBottom.toggle()
                }
            }){
                Text("Save")
                    .font(.title2)
                    .foregroundColor(oR)
            }
            .padding(.vertical, 10)
        }
        .padding(.horizontal, 20)
            
        .sheet(isPresented: $isUploadingDocument) {
            UploadFileView()
            Button(action: {
                isUploadingDocument = false
            }) {
                Text("Dismiss")
                    .font(.title2)
                    .foregroundColor(oR)
            }
        }
    }
        .padding()
        .navigationBarTitle("Trip Details", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {isUploadingDocument = true}) {
                    Image (systemName: "square.and.arrow.up")
                        .foregroundColor(oR)
                    
                }
                
            }
        }
    }
}
