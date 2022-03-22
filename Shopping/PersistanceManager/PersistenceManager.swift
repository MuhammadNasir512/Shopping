import Foundation

protocol PersistenceManagerType {
    func fetch() -> Any
    func persist(data: Any)
}

final class PersistenceManager: PersistenceManagerType {
    
    private let userDefaults: UserDefaults
    private let dataType: DataType
    
    init(dataType: DataType = .loginToken, userDefaults: UserDefaults = .standard) {
        self.dataType = dataType
        self.userDefaults = userDefaults
    }
        
    func fetch() -> Any {
        return userDefaults.object(forKey: dataType.rawValue) as Any
    }
    
    func persist(data: Any) {
        userDefaults.set(data, forKey: dataType.rawValue)
    }
}

extension PersistenceManager {
    enum DataType: String {
        case loginToken
    }
}
