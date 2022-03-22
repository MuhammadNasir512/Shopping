import SwiftUI

struct ProductsListView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        List(viewModel.productsList) { product in
            ProductListItemView(product: product, cart: viewModel.cart)
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
        .overlay(ProgressView().background(.white).opacity(viewModel.isLoading ? 1 : 0))
        .alert(isPresented: $viewModel.needsShowingErrorAlert) {
            Alert(title: Text(viewModel.error?.localizedDescription ?? "Unknown Error"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: retrieveProducts)
    }
    
    private func retrieveProducts() {
        viewModel.retrieveProducts()
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        let apiHandler = APIHandler()
        let category = Category(name: "Test Category")
        let viewModel = ProductsListView.ViewModel(category: category, cart: Cart(), apiHandler: apiHandler)
        ProductsListView(viewModel: viewModel)
    }
}
