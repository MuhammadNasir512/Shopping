import XCTest
@testable import Shopping

final class ProductsListViewModelTests: XCTestCase {

    func testSuccessfulLoadingOfProducts() throws {
        // Given
        let exp = XCTestExpectation(description: "Expectation1")
        let apiHandler = MockAPIHandler(urlString: "http:\\DummyUrlString.json")
        apiHandler.exp = exp
        let cart = Cart()
        let category = Category(name: "SomeCategoryName")
        let sut = ProductsListView.ViewModel(category: category, cart: cart, apiHandler: apiHandler)
        
        // When
        sut.retrieveProducts()
        wait(for: [exp], timeout: 1)
        
        // Then
        XCTAssertEqual(sut.productsList.count, 4)
    }
}
