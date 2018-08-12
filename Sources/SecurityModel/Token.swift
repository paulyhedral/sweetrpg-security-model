import Vapor
import FluentMySQL


final class Token : Content {
    var token : String

    init(token : String) {
        self.token = token
    }
}
