//
//  InstructionsView.swift
//  MyTripEra
//
//  Created by Ria Garg on 1/29/24.
//

import Foundation
import SwiftUI
import SwiftData
import MapKit
import CoreLocation

struct InstructionsView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to MyTripEra, your personal travel expert.")
                    .font(.title)
                    .padding(.horizontal, 50)
                    .multilineTextAlignment(.center)
                
                Divider()
                
                Text("Add and organize your grand adventures with just a few clicks. \n\nInput trip details and ask any questions about your travels. \n\nLet us keep track of your memories.")
                    .font(.title3)
                    .padding(.horizontal, 50)
                    .multilineTextAlignment(.center)
                
                    .navigationBarTitle("Welcome", displayMode: .inline)
            }
        }
    }
}
