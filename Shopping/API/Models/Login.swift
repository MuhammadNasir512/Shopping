import Foundation

struct Login: Codable {
    let username: String
    let password: String
    let email: String
}

struct Token: Codable {
    let token: String
}

func jsonData<Model: Codable>(from model: Model) -> Data? {
    return try? JSONEncoder().encode(model)
}
