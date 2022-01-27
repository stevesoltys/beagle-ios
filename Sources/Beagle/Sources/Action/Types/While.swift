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
/// It will continue to do so until the provided condition is met.
public struct While: AnalyticsAction, Decodable {

    /// Defines the time interval.
    public let timeInterval: Expression<Int>

    /// Defines the condition.
    public let condition: Expression<Bool>

    /// Defines the action triggered every tick.
    public let onTick: [Action]?

    /// Defines the action triggered when the condition is true.
    public let onFinish: [Action]?

    /// Defines an analytics configuration for this action.
    public let analytics: ActionAnalyticsConfig?

// sourcery:inline:auto:Alert.Init
    public init(
            timeInterval: Expression<Int>,
            condition: Expression<Bool>,
            onTick: [Action]? = nil,
            onFinish: [Action]? = nil,
            analytics: ActionAnalyticsConfig? = nil
    ) {
        self.timeInterval = timeInterval
        self.condition = condition
        self.onTick = onTick
        self.onFinish = onFinish
        self.analytics = analytics
    }

// sourcery:end

    enum CodingKeys: String, CodingKey {
        case timeInterval
        case condition
        case onTick
        case onFinish
        case analytics
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        timeInterval = try container.decode(Expression<Int>.self, forKey: .timeInterval)
        condition = try container.decode(Expression<Bool>.self, forKey: .condition)
        onTick = try container.decodeIfPresent(forKey: .onTick)
        onFinish = try container.decodeIfPresent(forKey: .onFinish)
        analytics = try container.decodeIfPresent(ActionAnalyticsConfig.self, forKey: .analytics)
    }
}
