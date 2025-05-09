import XCTest
@testable import FitoNyash

class CartViewControllerTests: XCTestCase {
    
    var sut: CartViewController!
    var mockPresenter: MockCartPresenter!
    
    override func setUp() {
        super.setUp()
        mockPresenter = MockCartPresenter()
        sut = CartViewController(presenter: mockPresenter)
    }
    
    override func tearDown() {
        sut = nil
        mockPresenter = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(sut.view.backgroundColor, AppColors.backgroundWhite)
        XCTAssertEqual(sut.topTitleLabel.text, "Корзина")
    }
    
    func testEmptyState() {
        // Given
        UserStorage.shared.cartOrder = []
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertFalse(sut.emptyStateLabel.isHidden)
        XCTAssertTrue(sut.totalPriceLabel.alpha == 0)
        XCTAssertTrue(sut.orderButton.alpha == 0)
    }
    
    func testNonEmptyState() {
        // Given
        let product = FoodList.cereal
        UserStorage.shared.cartOrder = [product]
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertTrue(sut.emptyStateLabel.isHidden)
        XCTAssertTrue(sut.totalPriceLabel.alpha == 1)
        XCTAssertTrue(sut.orderButton.alpha == 1)
    }
}

// MARK: - Mock Objects
class MockCartPresenter: CartPresenterProtocol {
    func loadCart() {
        // Mock implementation
    }
    
    func removeFromCart(at index: Int) {
        // Mock implementation
    }
    
    func calculateTotalPrice() -> Double {
        return 0.0
    }
} 
