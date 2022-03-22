import SwiftUI

class DataLoadingAndErrorHandlingViewModel {
    @Published var isLoading = false
    @Published var needsShowingErrorAlert = false
    @Published var error: Error? = nil
    
    let apiHandler: APIHandlerType

    init(apiHandler: APIHandlerType = APIHandler()) {
        self.apiHandler = apiHandler
    }
}

extension LoginView {
    
    final class ViewModel: DataLoadingAndErrorHandlingViewModel, ObservableObject {
        let loginHeaderText = Constant.loginHeaderText
        let usernamePlaceholder = Constant.usernamePlaceholder
        let passwordPlaceholder = Constant.passwordPlaceholder
        let loginButtonTitleText = Constant.loginButtonTitleText
        private let persistenceManager: PersistenceManagerType

        init(apiHandler: APIHandlerType = APIHandler(), persistenceManager: PersistenceManagerType = PersistenceManager()) {
            self.persistenceManager = persistenceManager
            super.init(apiHandler: apiHandler)
        }
        
        func doLogin(userName: String, password: String) {
            isLoading = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                let dummyToken = "eyJhbGciOiJIUzI1NiIsInR"
                self.persistenceManager.persist(data: dummyToken)
                self.isLoading = false
            }
            // Following code is commented as Login is not working properly
/*
            let loginDetails = Login(username: userName, password: password, email: "")
            apiHandler.login(details: loginDetails) { [weak self] result in
                switch result {
                case .failure(let error): self?.handleError(error: error)
                case .success(let data): self?.handleSuccess(data: data)
                }
                self?.isLoading = false
            }
 */
        }
        
        private func handleSuccess(data: Data) {
            do {
                let decoder = JSONDecoder()
                let token = try decoder.decode(Token.self, from: data)
                print("Token: \(token)")
            } catch let error as NSError {
                handleError(error: error)
            }
        }

        private func handleError(error: Error) {
            self.error = error
            needsShowingErrorAlert = true
        }
        
        private enum Constant {
            // ToDo Move following values to Localizable.strings
            static let loginHeaderText = "Password"
            static let usernamePlaceholder = "Username"
            static let passwordPlaceholder = "Password"
            static let loginButtonTitleText = "Login"
        }
    }
}
