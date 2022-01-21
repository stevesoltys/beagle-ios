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

public struct FirebaseSignIn: Action, Decodable, AnalyticsAction {

    /// The type of sign-in to perform.
    public let type: FirebaseSignInType

    /// The email expression, if using username/password auth.
    public let email: Expression<String>?

    /// The password expression, if using username/password auth.
    public let password: Expression<String>?

    /// Actions to be executed in request success case.
    public let onSuccess: [Action]?

    /// Actions to be executed in request error case.
    public let onError: [Action]?

    /// Actions to be executed in request completion case.
    public var onFinish: [Action]?

    /// Defines an analytics configuration for this action.
    public let analytics: ActionAnalyticsConfig?

    public init(
            type: FirebaseSignInType,
            email: Expression<String>? = nil,
            password: Expression<String>? = nil,
            onSuccess: [Action]? = nil,
            onError: [Action]? = nil,
            onFinish: [Action]? = nil,
            analytics: ActionAnalyticsConfig? = nil
    ) {
        self.type = type
        self.email = email
        self.password = password
        self.onSuccess = onSuccess
        self.onError = onError
        self.onFinish = onFinish
        self.analytics = analytics
    }

    enum CodingKeys: String, CodingKey {
        case email
        case password
        case type
        case onSuccess
        case onError
        case onFinish
        case analytics
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = try container.decode(FirebaseSignInType.self, forKey: .type)
        email = try container.decodeIfPresent(Expression<String>.self, forKey: .email)
        password = try container.decodeIfPresent(Expression<String>.self, forKey: .password)
        onSuccess = try container.decodeIfPresent(forKey: .onSuccess)
        onError = try container.decodeIfPresent(forKey: .onError)
        onFinish = try container.decodeIfPresent(forKey: .onFinish)
        analytics = try container.decodeIfPresent(ActionAnalyticsConfig.self, forKey: .analytics)
    }
}

public enum FirebaseSignInType: String, Decodable {
    case EMAIL_PASSWORD = "EMAIL_PASSWORD"
    case APPLE = "APPLE"
    case GOOGLE = "GOOGLE"
}