/*
 * Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

private var appleSignInController: AppleSignInController? = nil

extension FirebaseSignIn: AsyncAction {

    public func execute(controller: BeagleController, origin: UIView) {

        if (type == FirebaseSignInType.EMAIL_PASSWORD) {
            emailPasswordSignIn(controller: controller, origin: origin)

        } else if (type == FirebaseSignInType.APPLE) {
            appleSignIn(controller: controller, origin: origin)

        } else if (type == FirebaseSignInType.GOOGLE) {
            googleSignIn(controller: controller, origin: origin)
        }
    }

    func executeError(controller: BeagleController, origin: UIView, error: Error) {
        executeError(
                controller: controller,
                origin: origin,
                value: [
                    "message": "\(error.localizedDescription)"
                ]
        )
    }

    func executeError(controller: BeagleController, origin: UIView, value: DynamicObject) {
        DispatchQueue.main.async {
            controller.execute(actions: onError, with: "onError", and: value, origin: origin)
            controller.execute(actions: onFinish, event: "onFinish", origin: origin)
        }
    }

    func executeSuccess(controller: BeagleController, origin: UIView, value: DynamicObject) {
        DispatchQueue.main.async {
            controller.execute(actions: onSuccess, with: "onSuccess", and: value, origin: origin)
        }
    }

    func signIn(controller: BeagleController, origin: UIView, credential: AuthCredential) {

        Auth.auth().signIn(with: credential) { (authResult, error) in

            if let error = error {
                print("Sign in errored: \(error)")
                executeError(controller: controller, origin: origin, error: error)
                return
            }

            executeSuccess(
                    controller: controller,
                    origin: origin,
                    value: ["emailVerified": "\(authResult?.user.isEmailVerified ?? false)"]
            )
        }
    }

    private func emailPasswordSignIn(controller: BeagleController, origin: UIView) {

        guard let emailEvaluated = email?.evaluate(with: origin),
              let passwordEvaluated = password?.evaluate(with: origin) else {

            executeError(controller: controller, origin: origin, value: [
                "message": "Email and password cannot be empty."
            ])

            return
        }


        Auth.auth().signIn(withEmail: emailEvaluated, password: passwordEvaluated) { authResult, error in

            if let error = error {
                print("Sign in errored: \(error)")
                executeError(controller: controller, origin: origin, error: error)
                return
            }

            executeSuccess(
                    controller: controller,
                    origin: origin,
                    value: ["emailVerified": "\(authResult?.user.isEmailVerified ?? false)"]
            )
        }
    }

    private func googleSignIn(controller: BeagleController, origin: UIView) {

        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }

        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(with: config, presenting: controller) { user, error in

            if let error = error {
                executeError(controller: controller, origin: origin, error: error)
                return
            }

            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken else {
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                    accessToken: authentication.accessToken)

            signIn(controller: controller, origin: origin, credential: credential)
        }
    }

    private func appleSignIn(controller: BeagleController, origin: UIView) {
        if #available(iOS 13.0, *) {
            let nonce = randomNonceString()

            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)

            appleSignInController = AppleSignInController(
                    firebaseSignIn: self,
                    beagleController: controller,
                    origin: origin,
                    currentNonce: nonce
            )

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = appleSignInController
            authorizationController.presentationContextProvider = appleSignInController
            authorizationController.performRequests()

        } else {
            executeError(controller: controller, origin: origin, value: [
                "message": "Must be on iOS 13 or above to use Apple Sign In."
            ])
        }
    }
}

public class AppleSignInController: NSObject, ASAuthorizationControllerDelegate,
        ASAuthorizationControllerPresentationContextProviding {

    private let firebaseSignIn: FirebaseSignIn

    private let beagleController: BeagleController

    private let origin: UIView

    private let currentNonce: String

    @available(iOS 13, *)
    init(firebaseSignIn: FirebaseSignIn,
         beagleController: BeagleController,
         origin: UIView,
         currentNonce: String
    ) {
        self.firebaseSignIn = firebaseSignIn
        self.beagleController = beagleController
        self.origin = origin
        self.currentNonce = currentNonce
    }

    @available(iOS 13, *)
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.delegate!.window!!
    }

    @available(iOS 13, *)
    public func authorizationController(controller: ASAuthorizationController,
                                        didCompleteWithAuthorization authorization: ASAuthorization) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }

            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                    idToken: idTokenString,
                    rawNonce: currentNonce)

            firebaseSignIn.signIn(controller: beagleController, origin: origin, credential: credential)
        }
    }

    @available(iOS 13, *)
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")

        firebaseSignIn.executeError(controller: beagleController, origin: origin, error: error)
    }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
@available(iOS 13, *)
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
        let randoms: [UInt8] = (0..<16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }

        randoms.forEach { random in
            if length == 0 {
                return
            }

            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }

    return result
}

@available(iOS 13, *)
private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
                String(format: "%02x", $0)
            }
            .joined()

    return hashString
}
