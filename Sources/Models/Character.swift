import Vapor
import FluentProvider
import HTTP

final class Character: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the post
    var content: String
    
    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let content = "content"
    }

    /// Creates a new Post
    init(content: String) {
        self.content = content
    }

    // MARK: Fluent Serialization

    /// Initializes the Post from the
    /// database row
    init(row: Row) throws {
        content = try row.get(Character.Keys.content)
    }

    // Serializes the Post to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Character.Keys.content, content)
        return row
    }
}

// MARK: Fluent Preparation

extension Character: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Posts
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Post.Keys.content)
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
//     - Creating a new Post (POST /posts)
//     - Fetching a post (GET /posts, GET /posts/:id)
//
extension Character: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            content: try json.get(Character.Keys.content)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Character.Keys.id, id)
        try json.set(Character.Keys.content, content)
        return json
    }
}

// MARK: HTTP

// This allows Post models to be returned
// directly in route closures
extension Character: ResponseRepresentable { }

// MARK: Update

// This allows the Post model to be updated
// dynamically by the request.
extension Character: Updateable {
    // Updateable keys are called when `post.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<Post>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            UpdateableKey(Character.Keys.content, String.self) { character, content in
                character.content = content
            }
        ]
    }
}