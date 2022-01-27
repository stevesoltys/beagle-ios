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

public struct FirebaseSendVerificationEmail: Action, Decodable, AnalyticsAction {

    /// Actions to be executed in success case.
    public let onSuccess: [Action]?

    /// Actions to be executed in error case.
    public let onError: [Action]?

    /// Actions to be executed in completion case.
    public var onFinish: [Action]?

    /// Defines an analytics configuration for this action.
    public let analytics: ActionAnalyticsConfig?

    public init(
            onSuccess: [Action]? = nil,
            onError: [Action]? = nil,
            onFinish: [Action]? = nil,
            analytics: ActionAnalyticsConfig? = nil
    ) {
        self.onSuccess = onSuccess
        self.onError = onError
        self.onFinish = onFinish
        self.analytics = analytics
    }

    enum CodingKeys: String, CodingKey {
        case onSuccess
        case onError
        case onFinish
        case analytics
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        onSuccess = try container.decodeIfPresent(forKey: .onSuccess)
        onError = try container.decodeIfPresent(forKey: .onError)
        onFinish = try container.decodeIfPresent(forKey: .onFinish)
        analytics = try container.decodeIfPresent(ActionAnalyticsConfig.self, forKey: .analytics)
    }
}
