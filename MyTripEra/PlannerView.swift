//
//  PlannerView.swift
//  MyTripEra
//
//  Created by Ria Garg on 1/29/24.
//

import Foundation
import SwiftUI
import SwiftData
import MapKit
import CoreLocation

struct PlannerView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var input = ""
    @State private var answer = ""
    @State private var finished = false
    
    var body: some View {
        VStack() {
            Text("Need help with your trip?")
                .font(.title)
                .padding(.vertical, 10)
            
            Text("Tell us what you're looking for.".uppercased())
                .font(.headline)
                .padding(.bottom, 10)
            Divider()
        
            
        ScrollView {
            ScrollViewReader { scrollView in
                LazyVStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading) {
                        Text(answer)
                            .padding(.bottom, 5) // Adjust padding as needed
                        Divider()
                            .background(Color.gray)
                            .frame(height: 1)
                    }
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 20)
                Spacer()
            }
        }
        .frame(maxHeight: 500)
        
        Spacer()
            
        HStack {
            TextEditor(text: $input)
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
                finished = true
                generateText()
                if !input.isEmpty {
                    input = ""
                }
            }){
                Text("Brainstorm")
                    .font(.title2)
                    .foregroundColor(oR)
            }
            .padding(.vertical, 10)
        }
        .padding(.horizontal, 5)
    }
        .padding()
        .navigationBarTitle("Trip Ideas", displayMode: .inline)
    }
    
    func generateText() {
        let apiKey = "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"
        let url = URL(string: "https://api.openai.com/v1/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo-instruct",
            "prompt": "The user would like a recommendation for what trip and itinerary to make based on their requirements. Please provide a very concise and to-the-point answer without any extraneous content to the request: \(input). Address the answer directly to 'you' to maintain a personal and direct tone. If the user asks about something regarding the type of the trip, be sure to mention the type, such as road or flight.",
            "max_tokens": 2000,
            "temperature": 0
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                print("JSON Response:", jsonResponse)
                
                if let json = jsonResponse as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let choice = choices.first,
                   let text = choice["text"] as? String {
                    if text.isEmpty {
                            DispatchQueue.main.async {
                                self.answer = "No response generated for the given prompt."
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.answer = text
                            }
                        }
                } else {
                    print("Unable to parse response")
                }
            } catch {
                print("Error decoding response: \(error)")
                print("Response String:", String(data: data, encoding: .utf8) ?? "Unable to decode response data")
            }
        }.resume()
    }
    
}
