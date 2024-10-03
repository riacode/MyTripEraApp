//
//  TripCreationView.swift
//  MyTripEra
//
//  Created by Ria Garg on 1/26/24.
//

import Foundation
import SwiftUI
import SwiftData
import MapKit
import CoreLocation

struct TripCreationView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isCreatingTrip: Bool // not private, have to see
    @State private var tripType = ""
    @State private var tripName = ""
    let addItem: (String, String) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Trip Type", selection: $tripType) {
                    Text("Road").tag("Road")
                    Text("Flight").tag("Flight")
                    Text("Other").tag("Other")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .font(.title)
                .padding(.top,20)
                .padding(.bottom,20)
                
                TextField("Trip Name", text: $tripName)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 10) // Add horizontal padding
                    .frame(width: 300)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                            RoundedRectangle(cornerRadius: 5) // Adjust the corner radius as needed
                                .stroke(oR, lineWidth: 2) // Set your desired color and line width
                        )

                Spacer()
                HStack {
                    Button(action: {
                        isCreatingTrip = false
                    }) {
                        Text("Cancel")
                            .font(.title2)
                            .foregroundColor(oR)
                            .padding(.horizontal, 15)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isCreatingTrip = false
                        addItem(tripName, tripType)
                    }) {
                        Text("Create")
                            .font(.title2)
                            .foregroundColor(oR)
                            .padding(.horizontal, 15)
                    }
                }
                .padding()
                .navigationBarTitle("Create Trip", displayMode: .inline)
            }
        }
    }
}
