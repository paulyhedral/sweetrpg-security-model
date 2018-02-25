import Vapor
import FluentProvider
import HTTP

final class Rating: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the Rating
    var content: String
    
    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let content = "content"
    }

    /// Creates a new Rating
    init(content: String) {
        self.content = content
    }

    // MARK: Fluent Serialization

    /// Initializes the Rating from the
    /// database row
    init(row: Row) throws {
        content = try row.get(Rating.Keys.content)
    }

    // Serializes the Rating to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Rating.Keys.content, content)
        return row
    }
}

// MARK: Fluent Preparation

extension Rating: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Ratings
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Rating.Keys.content)
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
//     - Creating a new Rating (Rating /Ratings)
//     - Fetching a Rating (GET /Ratings, GET /Ratings/:id)
//
extension Rating: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            content: try json.get(Rating.Keys.content)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Rating.Keys.id, id)
        try json.set(Rating.Keys.content, content)
        return json
    }
}

// MARK: HTTP

// This allows Rating models to be returned
// directly in route closures
extension Rating: ResponseRepresentable { }

// MARK: Update

// This allows the Rating model to be updated
// dynamically by the request.
extension Rating: Updateable {
    // Updateable keys are called when `Rating.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<Rating>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            UpdateableKey(Rating.Keys.content, String.self) { Rating, content in
                Rating.content = content
            }
        ]
    }
}
