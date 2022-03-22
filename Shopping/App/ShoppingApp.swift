import SwiftUI

@main
struct ShoppingApp: App {
    let persistenceManager = PersistenceManager()
    @ObservedObject var loginViewModel = LoginView.ViewModel()
    @ObservedObject var cart = Cart()

    @ViewBuilder
    var body: some Scene {
        WindowGroup {
            if let loginToken = persistenceManager.fetch() as? String, !loginToken.isEmpty {
                let apiHandler = APIHandler()
                let viewModel = CategoriesListView.ViewModel(cart: cart, apiHandler: apiHandler)
                CategoriesListView(viewModel: viewModel)
            }
            else {
                LoginView(viewModel: loginViewModel)
            }
        }
    }
}
