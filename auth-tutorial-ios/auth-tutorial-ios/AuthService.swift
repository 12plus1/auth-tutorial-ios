import Foundation
import AppAuth

class AuthService {
    var currentAuthFlow: OIDExternalUserAgentSession?
    
    private let authEndpoint = URL(string: "http://localhost:4444/oauth2/auth")!
    private let tokenEndpoint = URL(string: "http://localhost:4444/oauth2/token")!
    private let redirectURL = URL(string: "com.example-app:/oauth2/callback")!
    private let clientId = "test-client"
    private let clientSecret = "test-secret"
    private lazy var config = OIDServiceConfiguration(authorizationEndpoint: authEndpoint, tokenEndpoint: tokenEndpoint)
    
    func authorize(from vc: UIViewController, onSuccess: @escaping (OIDAuthState) -> Void, onError: @escaping (Error) -> Void) {
        let request = OIDAuthorizationRequest(configuration: config,
                                              clientId: clientId,
                                              clientSecret: clientSecret,
                                              scopes: [OIDScopeOpenID, "offline"],
                                              redirectURL: redirectURL,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: nil)
        currentAuthFlow = OIDAuthState.authState(byPresenting: request, presenting: vc, callback: { (authState, error) in
            if let authState = authState {
                print(authState)
                onSuccess(authState)
            } else if let error = error {
                print(error)
                onError(error)
            }
        })
    }
}
