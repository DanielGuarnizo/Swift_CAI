//
//  ToDoListItem.swift
//  cai
//
//  Created by Daniel Guarnizo on 12/04/24.
//

import Foundation

struct ToDoListItem: Codable, Identifiable {
    let id: String
    let title: String
    let dueDate: TimeInterval
    let createdDate: TimeInterval
    var isDone: Bool

    // thsi keyword "mutating" is neede because by default methods on value types are not allowed to modify the instance's properties.
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
}
