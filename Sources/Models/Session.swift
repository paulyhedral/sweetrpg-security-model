import Vapor
import FluentProvider
import HTTP

final class Session: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the Session
    var content: String
    
    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let content = "content"
    }

    /// Creates a new Session
    init(content: String) {
        self.content = content
    }

    // MARK: Fluent Serialization

    /// Initializes the Session from the
    /// database row
    init(row: Row) throws {
        content = try row.get(Session.Keys.content)
    }

    // Serializes the Session to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Session.Keys.content, content)
        return row
    }
}

// MARK: Fluent Preparation

extension Session: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Sessions
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Session.Keys.content)
        }
    }

    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//     - Creating a new Session (Session /Sessions)
//     - Fetching a Session (GET /Sessions, GET /Sessions/:id)
//
extension Session: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            content: try json.get(Session.Keys.content)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Session.Keys.id, id)
        try json.set(Session.Keys.content, content)
        return json
    }
}

// MARK: HTTP

// This allows Session models to be returned
// directly in route closures
extension Session: ResponseRepresentable { }

// MARK: Update

// This allows the Session model to be updated
// dynamically by the request.
extension Session: Updateable {
    // Updateable keys are called when `Session.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<Session>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            UpdateableKey(Session.Keys.content, String.self) { Session, content in
                Session.content = content
            }
        ]
    }
}
