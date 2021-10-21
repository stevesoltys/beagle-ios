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

/// The `RemoveChildren` action is responsible for removing components from a component hierarchy.
public struct RemoveChildren: AnalyticsAction {

    /// Defines the widget's id, in which you want to remove the views.
    public let componentId: String

    /// Defines the child index you want to remove.
    public let index: Int

    /// Defines an analytics configuration for this action.
    public let analytics: ActionAnalyticsConfig?

    public init(
            componentId: String,
            index: Int,
            analytics: ActionAnalyticsConfig? = nil
    ) {
        self.componentId = componentId
        self.index = index
        self.analytics = analytics
    }

    // MARK: Decodable

    enum CodingKeys: String, CodingKey {
        case componentId
        case index
        case analytics
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        componentId = try container.decode(String.self, forKey: .componentId)
        index = try container.decode(Int.self, forKey: .index)
        analytics = try container.decodeIfPresent(ActionAnalyticsConfig.self, forKey: .analytics)
    }
}
