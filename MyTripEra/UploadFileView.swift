//
//  UploadFileView.swift
//  MyTripEra
//
//  Created by Ria Garg on 2/15/24.
//

import Foundation
import SwiftUI
import SwiftData
import MapKit
import CoreLocation

struct UploadFileView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Document Details")) {
                }

                Section {
                    Button(action: uploadDocument) {
                        HStack {
                            Image(systemName: "arrow.up.doc")
                            Text("Upload Document")
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Upload File")
        }
    }

    func uploadDocument() {
        print("Uploading document...")
    }
}

