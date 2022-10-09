//
//  Todo.swift
//  SimpleTodo
//
//  Created by Ben Scheirman on 7/29/22.
//

import Foundation

struct Todo: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()

    var text: String
    var completedAt: Date?
    var sortOrder = 0

    var isCompleted: Bool {
        get { completedAt != nil }
        set { completedAt = newValue ? Date() : nil }
    }
}

extension Todo {
    init(_ text: String, completedAt: Date? = nil, sortOrder: Int = 0) {
        self.text = text
        self.completedAt = completedAt
        self.sortOrder = sortOrder
    }
}

extension Array where Element == Todo {
    static var sample: Self {
        [
            .init("Wash the car"),
            .init("Walk the dogs"),
            .init("Buy groceries"),
            .init("Record a screencast", completedAt: Date()),
            .init("Super important task", sortOrder: -1),
        ].sorted()
    }

    func sorted() -> Self {
        sorted(by: { $0.sortOrder < $1.sortOrder })
    }
}
