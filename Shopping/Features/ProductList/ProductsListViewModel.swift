import Foundation
import SwiftUI

extension ProductsListView {
    
    final class ViewModel: DataLoadingAndErrorHandlingViewModel, ObservableObject {
        let screenTitle = Constant.screenTitle
        @Published var productsList = [Product]()
        @Published var cart: Cart
        private let category: Category
        
        init(category: Category, cart: Cart, apiHandler: APIHandlerType) {
            self.category = category
            self.cart = cart
            super.init(apiHandler: apiHandler)
        }

        func retrieveProducts() {
            isLoading = true
            apiHandler.getProducts(category: category.name) { [weak self] result in
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
                let items = try decoder.decode([Product].self, from: data)
                productsList = items
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
            static let screenTitle = "products"
        }
    }
}
