// Content of KeepSources.swift
import OSLog
import RealmSwift

// MARK: - Todo

public class Todo: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var name: String = ""
  @Persisted var status: String = ""
  @Persisted var ownerId: String
  public convenience init(name: String, ownerId: String) {
    self.init()
    self.name = name
    self.ownerId = ownerId
  }
}

// MARK: - TodoSingleTone

public final class TodoSingleTone {
  public static let shared = TodoSingleTone()
  public init() {}
  let realm = try! Realm()
  public func save() {
    let todo = Todo(name: "Do laundry", ownerId: "123")
    try! realm.write {
      realm.add(todo)
      realm.add(todo)
    }
  }

  public func load() {
    let todos = realm.objects(Todo.self)
    os_log("\(todos)")
  }
}
