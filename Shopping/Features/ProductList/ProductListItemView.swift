import SwiftUI

struct ProductListItemView: View {
    let product: Product
    var cart: Cart
    
    init(product: Product, cart: Cart) {
        self.product = product
        self.cart = cart
    }
    
    private func formattedPrice(_ price: Double) -> String {
        String(format: "Price: £%.02f", price)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(product.title).dynamicTypeSize(.medium)
            Text(formattedPrice(product.price)).dynamicTypeSize(.small).foregroundColor(.blue)
            HStack {
                Group {
                    Text("Remove to Cart")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.red)
                        .clipShape(Capsule()).onTapGesture {
                            guard let index = cart.items.firstIndex(of: product) else { return }
                            cart.items.remove(at: index)
                        }
                }
                Spacer()
                Group {
                    Text("Add to Cart")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.green)
                        .clipShape(Capsule()).onTapGesture {
                            cart.items.append(product)
                        }
                }
            }
        }
    }
    
    private enum Constant {
        static let addDeleteButtonPadding: CGFloat = 7
    }
}

struct ProductListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let cart = Cart()
        let product = Product(id: 12, title: "Good Product", price: 5.12, description: "Very good product")
        ProductListItemView(product: product, cart: cart)
    }
}
