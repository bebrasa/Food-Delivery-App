import XCTest
@testable import FitoNyash

class LoginViewControllerTests: XCTestCase {
    
    var sut: LoginViewController!
    var mockViewOutput: MockLoginViewOutput!
    
    override func setUp() {
        super.setUp()
        mockViewOutput = MockLoginViewOutput()
        sut = LoginViewController(viewOutput: mockViewOutput, state: .base)
    }
    
    override func tearDown() {
        sut = nil
        mockViewOutput = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(sut.view.backgroundColor, AppColors.accentGreen)
    }
    
    func testSignInButtonTappedInBaseState() {
        // Given
        sut = LoginViewController(viewOutput: mockViewOutput, state: .base)
        
        // When
        sut.onSignInTapped()
        
        // Then
        XCTAssertTrue(mockViewOutput.goToSignInCalled)
    }
    
    func testSignUpButtonTappedInBaseState() {
        // Given
        sut = LoginViewController(viewOutput: mockViewOutput, state: .base)
        
        // When
        sut.onSignUpTapped()
        
        // Then
        XCTAssertTrue(mockViewOutput.goToSignUpCalled)
    }
    
    func testLoginStartWithCredentials() {
        // Given
        sut = LoginViewController(viewOutput: mockViewOutput, state: .login)
        sut.signInUsername.text = "test@example.com"
        sut.signInPassword.text = "password123"
        
        // When
        sut.onSignInTapped()
        
        // Then
        XCTAssertEqual(mockViewOutput.loginCredentials?.login, "test@example.com")
        XCTAssertEqual(mockViewOutput.loginCredentials?.password, "password123")
    }
    
    func testRegistrationStartWithCredentials() {
        // Given
        sut = LoginViewController(viewOutput: mockViewOutput, state: .signUp)
        sut.signUpUsername.text = "test@example.com"
        sut.signUpPassword.text = "password123"
        sut.signUpReEnterPassword.text = "password123"
        
        // When
        sut.onSignInTapped()
        
        // Then
        XCTAssertEqual(mockViewOutput.registrationCredentials?.email, "test@example.com")
        XCTAssertEqual(mockViewOutput.registrationCredentials?.password, "password123")
        XCTAssertEqual(mockViewOutput.registrationCredentials?.reEnterPassword, "password123")
    }
}

// MARK: - Mock Objects
class MockLoginViewOutput: LoginViewOutput {
    func goToForgotPassword() {
        
    }
    
    func back() {
        
    }
    
    var goToSignInCalled = false
    var goToSignUpCalled = false
    var loginCredentials: (login: String, password: String)?
    var registrationCredentials: (email: String, password: String, reEnterPassword: String)?
    
    func goToSignIn() {
        goToSignInCalled = true
    }
    
    func goToSignUp() {
        goToSignUpCalled = true
    }
    
    func loginStart(login: String, password: String) {
        loginCredentials = (login, password)
    }
    
    func registaionStart(email: String, password: String, reEnterPassword: String) {
        registrationCredentials = (email, password, reEnterPassword)
    }
} 
