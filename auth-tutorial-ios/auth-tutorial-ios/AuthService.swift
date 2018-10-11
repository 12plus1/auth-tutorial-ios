import Foundation
import AppAuth

protocol AuthServiceError: Error {}

class AuthService {
    struct FailedToAuthenticate: AuthServiceError, UnderlyingError { let underlying: Error? }
    
    var currentAuthFlow: OIDExternalUserAgentSession?
    
    private let authEndpoint = URL(string: "http://localhost:4444/oauth2/auth")!
    private let tokenEndpoint = URL(string: "http://localhost:4444/oauth2/token")!
    private let redirectURI = URL(string: "com.example.app:/oauth2/callback")!
    private let clientId = "test-client"
    private let clientSecret = "test-secret"
    private lazy var config = OIDServiceConfiguration(authorizationEndpoint: authEndpoint, tokenEndpoint: tokenEndpoint)
    
    func authorize(from vc: UIViewController, onSuccess: @escaping (OIDAuthState) -> Void, onError: @escaping (Error) -> Void) {
        let request = OIDAuthorizationRequest(configuration: config,
                                              clientId: clientId,
                                              clientSecret: clientSecret,
                                              scopes: [OIDScopeOpenID, "offline"],
                                              redirectURL: redirectURI,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: nil)
        currentAuthFlow = OIDAuthState.authState(byPresenting: request, presenting: vc, callback: { (authState, error) in
            if let authState = authState {
                print(authState)
                onSuccess(authState)
            } else {
                onError(FailedToAuthenticate(underlying: error))
            }
        })
    }
}

protocol UnderlyingError: Error {
    var underlying: Error? { get }
}

protocol LocalizedUnderlyingError: LocalizedError, UnderlyingError {}
