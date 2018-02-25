import Vapor
import FluentProvider
import HTTP

final class Profile: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the Profile
    var content: String
    
    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let bio = "bio"
        static let gameSystems = "gameSystems"
        static let location = "location"
        static let characters = "characters"
        static let avatar = "avatar"
        static let contactInfo = "contactInfo"
        static let tags = "tags"
    }

    /// Creates a new Profile
    init(content: String) {
        self.content = content
    }

    // MARK: Fluent Serialization

    /// Initializes the Profile from the
    /// database row
    init(row: Row) throws {
        content = try row.get(Profile.Keys.content)
    }

    // Serializes the Profile to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Profile.Keys.content, content)
        return row
    }
}

// MARK: Fluent Preparation

extension Profile: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Profiles
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Profile.Keys.content)
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
//     - Creating a new Profile (Profile /Profiles)
//     - Fetching a Profile (GET /Profiles, GET /Profiles/:id)
//
extension Profile: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            content: try json.get(Profile.Keys.content)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Profile.Keys.id, id)
        try json.set(Profile.Keys.content, content)
        return json
    }
}

// MARK: HTTP

// This allows Profile models to be returned
// directly in route closures
extension Profile: ResponseRepresentable { }

// MARK: Update

// This allows the Profile model to be updated
// dynamically by the request.
extension Profile: Updateable {
    // Updateable keys are called when `Profile.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<Profile>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            UpdateableKey(Profile.Keys.content, String.self) { Profile, content in
                Profile.content = content
            }
        ]
    }
}
