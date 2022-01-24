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

/// BottomNavigationBar is a component responsible to display a bottom navigation bar layout.
/// It works by displaying tabs that can change a context when clicked.
public struct BottomNavigationBar: Widget, Decodable {
    
    /// Defines yours tabs title and icon.
    public let items: [BottomNavigationBarItem]

    /// Defines the expression that is observed to change the current tab selected.
    public let currentTab: Expression<Int>?

    /// Defines a list of action that will be executed when a tab is selected.
    public let onTabSelection: [Action]?

    public let barTintColor: Expression<String>?

    public let tintColor: Expression<String>?

    public var widgetProperties: WidgetProperties

    public init(
            items: [BottomNavigationBarItem],
            currentTab: Expression<Int>? = nil,
            onTabSelection: [Action]? = nil,
            barTintColor: Expression<String>? = nil,
            tintColor: Expression<String>? = nil,
            widgetProperties: WidgetProperties = WidgetProperties()
    ) {
        self.items = items
        self.currentTab = currentTab
        self.onTabSelection = onTabSelection
        self.barTintColor = barTintColor
        self.tintColor = tintColor
        self.widgetProperties = widgetProperties
    }

    enum CodingKeys: String, CodingKey {
        case items
        case currentTab
        case onTabSelection
        case barTintColor
        case tintColor
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        items = try container.decode([BottomNavigationBarItem].self, forKey: .items)
        currentTab = try container.decodeIfPresent(Expression<Int>.self, forKey: .currentTab)
        onTabSelection = try container.decodeIfPresent(forKey: .onTabSelection)
        barTintColor = try container.decode(Expression<String>.self, forKey: .barTintColor)
        tintColor = try container.decode(Expression<String>.self, forKey: .tintColor)
        widgetProperties = try WidgetProperties(from: decoder)
    }
}

/// Defines the view item in the tab view
public struct BottomNavigationBarItem: Decodable {

    public let selectedIconPath: Expression<String>

    public let unselectedIconPath: Expression<String>

    public let title: String?

    public init(
            selectedIconPath: Expression<String>,
            unselectedIconPath: Expression<String>,
            title: String? = nil
    ) {
        self.selectedIconPath = selectedIconPath
        self.unselectedIconPath = unselectedIconPath
        self.title = title
    }

    enum CodingKeys: String, CodingKey {
        case selectedIconPath
        case unselectedIconPath
        case title
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        selectedIconPath = try container.decode(Expression<String>.self, forKey: .selectedIconPath)
        unselectedIconPath = try container.decode(Expression<String>.self, forKey: .unselectedIconPath)
        title = try container.decodeIfPresent(String.self, forKey: .title)
    }
}
