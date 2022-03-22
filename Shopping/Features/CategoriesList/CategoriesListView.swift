import SwiftUI

struct CategoriesListView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            List(viewModel.categoriesList) { category in
                NavigationLinkView(category: category, cart: viewModel.cart)
            }
            .navigationBarItems(trailing: HStack {
                HStack {
                    Image(systemName: "cart").font(.title2)
                    Text("\(viewModel.cart.items.count)")
                }
                .foregroundColor(.blue)
            })
            .listStyle(.plain)
            .navigationTitle(viewModel.screenTitle)
        }
        .overlay(ProgressView().background(.white).opacity(viewModel.isLoading ? 1 : 0))
        .alert(isPresented: $viewModel.needsShowingErrorAlert) {
            Alert(title: Text(viewModel.error?.localizedDescription ?? "Unknown Error"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: retrieveCategories)
    }
    
    private func retrieveCategories() {
        viewModel.retrieveCategories()
    }
}

struct CategoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        let apiHandler = APIHandler()
        let viewModel = CategoriesListView.ViewModel(cart: Cart(), apiHandler: apiHandler)
        CategoriesListView(viewModel: viewModel)
    }
}

struct NavigationLinkView: View {
    let category: Category
    @ObservedObject var cart: Cart
    
    var body: some View {
        let apiHandler = APIHandler()
        let viewModel = ProductsListView.ViewModel(category: category, cart: cart, apiHandler: apiHandler)
        let productsListView = ProductsListView(viewModel: viewModel)

        return NavigationLink(destination: productsListView) {
            Text(category.name).padding(.bottom).padding(.top)
        }
    }
}
