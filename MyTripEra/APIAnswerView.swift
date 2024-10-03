//
//  APIAnswerView.swift
//  MyTripEra
//
//  Created by Ria Garg on 1/26/24.
//

import Foundation
import SwiftUI
import SwiftData
import MapKit
import CoreLocation

struct APIAnswerView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var question: String
    @State private var answer = "Your answer is..."
    var items: [Item]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(question)
                    .font(.title2)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                
                Divider()
                
                Text(answer)
                    .font(.title2)
                    .padding(.horizontal, 20)
                
                Spacer()
                    .padding(.top,20)
                
                    .navigationBarTitle("Trip Trivia", displayMode: .inline)
            }
            .onAppear {
                generateText()
            }
        }
    }
    
    func generateText() {
        let apiKey = "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"
        let url = URL(string: "https://api.openai.com/v1/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var allTripInputs = ""
        for item in items {
            allTripInputs += "Name of Trip is " + item.name + " (Type is " + item.type + "): "
            for input in item.allInputs {
                allTripInputs += input + " "
            }
        allTripInputs += "\n NEXT TRIP \n"
        }
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo-instruct",
            "prompt": "Please provide a very concise and to-the-point answer without any extraneous content, in less than four sentences, to the question: \(question). Here is the information about all the trips: \(allTripInputs). The input format for each trip is specified as follows: 'Name of Trip is <name> (Type is <type>): [information about that trip] \n NEXT TRIP \n'.  This is repeated for every trip, hence the 'NEXT TRIP' text. This format clearly separates each trip's details, including its name, type (e.g., road, flight), and relevant information. Address the answer directly to 'you' to maintain a personal and direct tone. If the user asks about something regarding the type of the trip, be sure to mention the type, such as road or flight.",
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

