//
//  TodoList.swift
//  SimpleTodo
//
//  Created by Ben Scheirman on 7/29/22.
//

import SwiftUI

struct TodoList: View {
    @ObservedObject var controller: TodosController
    @FocusState var focusedTodoID: UUID?

    @State private var todos: [Todo] = []

    var body: some View {
        ZStack {
            List {
                ForEach(todos) { todo in
                    TodoRow(todo: .init(get: {
                        todo
                    }, set: { mutatedTodo in
                        let isToggleChange = mutatedTodo.isCompleted != todo.isCompleted
                        controller.update(mutatedTodo)
                        if isToggleChange {
                            print("Toggled!")
                            handleToggleChange(todo)
                        }
                    }))
                        .listRowSeparator(.hidden)
                        .focused($focusedTodoID, equals: todo.id)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive, action: {
                                withAnimation {
                                    controller.remove(todo)
                                }
                            }) {
                                Label("Delete Todo", systemImage: "trash")
                            }
                        }
                }
                .onMove(perform: move)            }
            .scrollDismissesKeyboard(.immediately)
            .listStyle(.plain)

            Button(action: {
                let newTodo = Todo("")
                withAnimation {
                    controller.add(newTodo)
                    focusedTodoID = newTodo.id
                }
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                    .background(
                        Circle().fill(Color.accentColor)
                    )
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom)
        }
        .onReceive(controller.store.$items) { todos in
            self.todos = todos.sorted()
        }
    }

    private func move(from source: IndexSet, to destination: Int) {
        var copy = todos
        copy.move(fromOffsets: source, toOffset: destination)
        copy.indices.forEach {
            copy[$0].sortOrder = $0
        }
        controller.updateAll(copy)
    }

    private func handleToggleChange(_ todo: Todo) {
        guard let originalIndex = todos.firstIndex(where: { $0.id == todo.id }) else {
            return
        }

        for index in todos.indices.reversed() where index != originalIndex {
            if todos[index].isCompleted {
                continue
            }
            withAnimation {
                move(from: .init(integer: originalIndex), to: index + 1)
            }
            break
        }
    }
}


struct TodoList_Previews: PreviewProvider {
    struct DemoView: View {
        @StateObject var controller = TodosController()
        var body: some View {
            TodoList(controller: controller)
        }
    }
    static var previews: some View {
        DemoView()
    }
}
