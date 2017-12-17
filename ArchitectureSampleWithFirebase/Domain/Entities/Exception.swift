import Foundation

enum Exception: Error {
    case network
    case auth
    case server
    case generic(message: String)
    case unknown
}
