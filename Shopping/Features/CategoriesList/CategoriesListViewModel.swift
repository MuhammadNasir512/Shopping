import Foundation
import SwiftUI

extension CategoriesListView {
    
    final class ViewModel: DataLoadingAndErrorHandlingViewModel, ObservableObject {
        let screenTitle = Constant.screenTitle
        @Published var categoriesList = [Category]()
        @Published var cart: Cart
        
        init(cart: Cart, apiHandler: APIHandlerType) {
            self.cart = cart
            super.init(apiHandler: apiHandler)
        }

        func retrieveCategories() {
            isLoading = true
            apiHandler.getCategories() { [weak self] result in
                switch result {
                case .failure(let error): self?.handleError(error: error)
                case .success(let data): self?.handleSuccess(data: data)
                }
                self?.isLoading = false
            }
        }
        
        private func handleSuccess(data: Data) {
            do {
                let decoder = JSONDecoder()
                let items = try decoder.decode([String].self, from: data)
                categoriesList = items.map { Category(name: $0) }
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
            static let screenTitle = "Categories"
        }
    }
}

class Cart: ObservableObject {
    @Published var items = [Product]()
}
