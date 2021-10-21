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

/// This action will wait a certain amount of time, and then execute the given action afterwards.
public struct Wait: AnalyticsAction, Decodable {

    /// Defines the title on the alert.
    public let time: Expression<Int>

    /// Defines the action triggered when the wait time has elapsed.
    public let onFinish: [Action]?

    /// Defines an analytics configuration for this action.
    public let analytics: ActionAnalyticsConfig?

// sourcery:inline:auto:Alert.Init
    public init(
            time: Expression<Int>,
            onFinish: [Action]? = nil,
            analytics: ActionAnalyticsConfig? = nil
    ) {
        self.time = time
        self.onFinish = onFinish
        self.analytics = analytics
    }
// sourcery:end
    
    enum CodingKeys: String, CodingKey {
        case time
        case onFinish
        case analytics
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        time = try container.decode(Expression<Int>.self, forKey: .time)
        onFinish = try container.decodeIfPresent(forKey: .onFinish)
        analytics = try container.decodeIfPresent(ActionAnalyticsConfig.self, forKey: .analytics)
    }
}
