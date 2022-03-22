import Foundation

struct Product: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let price: Double
    let description: String
//    let image: String
}
