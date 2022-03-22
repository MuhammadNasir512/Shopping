import Foundation

struct Category: Identifiable {
    let id: String
    let name: String
    
    init(name: String) {
        self.name = name
        id = UUID().uuidString
    }
}
