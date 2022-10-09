import SwiftUI
import Boutique

//extension Store where Item == Todo {
//    static var todos: Store<Todo> {
//        Store<Todo>(
//            storage: SQLiteStorageEngine.default(appendingPath: "todos"),
//            cacheIdentifier: \.id.uuidString
//        )
//    }
//}

final class TodosController: ObservableObject {
    // @Stored(in: .todos) var todos

    let store: Store<Todo>

    var todos: [Todo] {
        get async {
            await store.items
        }
    }

    init() {
        store = Store<Todo>(
            storage: SQLiteStorageEngine.default(appendingPath: "todos"),
            cacheIdentifier: \.id.uuidString
        )
    }

    func add(_ todo: Todo) {
        Task {
            do {
                try await store.add(todo)
            } catch {
                print(error)
            }
        }
    }

    func update(_ todo: Todo) {
        Task {
            do {
                try await store
                    .remove(todo)
                    .add(todo)
                    .run()
            } catch {
                print(error)
            }
        }
    }

    func updateAll(_ todos: [Todo]) {
        Task {
            do {
                try await store
                    .remove(todos)
                    .add(todos)
                    .run()
            } catch {
                print(error)
            }
        }
    }

    func remove(_ todo: Todo) {
        Task {
            do {
                try await store.remove(todo)
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView: View {
    @StateObject var todosController = TodosController()

    var body: some View {
        TodoList(controller: todosController)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
