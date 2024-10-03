//
//  Item.swift
//  MyTripEra
//
//  Created by Ria Garg on 1/23/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var name: String
    var type: String
    var allInputs: [String]

    init(name: String, type: String, allInputs: [String]) {
        self.name = name
        self.type = type
        self.allInputs = allInputs
    }
}
