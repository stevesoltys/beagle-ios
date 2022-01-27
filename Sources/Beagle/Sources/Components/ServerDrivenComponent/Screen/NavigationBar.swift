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

import Foundation
import UIKit

/// Typically displayed at the top of the window, containing buttons for navigating within a hierarchy of screens.
public struct NavigationBar: Decodable, AutoInitiable {

    /// Defines the title on the navigation bar.
    public let title: String?

    /// Could define a custom layout for your action bar/navigation bar.
    public let styleId: String?

    /// Navigation bar style.
    public let navigationBarStyle: NavigationBarStyle?

    /// Enables a back button into your action bar/navigation bar.
    public let showBackButton: Bool?

    /// Defines accessibility details for the back button.
    public let backButtonAccessibility: Accessibility?

    /// Defines a List of navigation bar items.
    public let navigationBarItems: [NavigationBarItem]?

    /// Defines a search bar.
    public let searchBar: SearchBar?

// sourcery:inline:auto:NavigationBar.Init
    public init(
            title: String?,
            styleId: String? = nil,
            navigationBarStyle: NavigationBarStyle? = nil,
            showBackButton: Bool? = nil,
            backButtonAccessibility: Accessibility? = nil,
            navigationBarItems: [NavigationBarItem]? = nil,
            searchBar: SearchBar? = nil
    ) {
        self.title = title
        self.styleId = styleId
        self.navigationBarStyle = navigationBarStyle
        self.showBackButton = showBackButton
        self.backButtonAccessibility = backButtonAccessibility
        self.navigationBarItems = navigationBarItems
        self.searchBar = searchBar
    }

// sourcery:end
}

/// Defines a search bar in the navigation bar.
public struct SearchBar: Decodable {

    public let placeholder: String?

    public let hideWhenScrolling: Bool?

    public let onQueryUpdated: [Action]?

    public init(
            placeholder: String? = nil,
            hideWhenScrolling: Bool? = nil,
            onQueryUpdated: [Action]? = nil
    ) {
        self.placeholder = placeholder
        self.hideWhenScrolling = hideWhenScrolling
        self.onQueryUpdated = onQueryUpdated
    }

    enum CodingKeys: String, CodingKey {
        case placeholder
        case hideWhenScrolling
        case onQueryUpdated
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        placeholder = try container.decodeIfPresent(String.self, forKey: .placeholder)
        hideWhenScrolling = try container.decodeIfPresent(Bool.self, forKey: .hideWhenScrolling)
        onQueryUpdated = try container.decodeIfPresent(forKey: .onQueryUpdated)
    }
}


/// Defines a item that could be showed in navigation bar.
public struct NavigationBarItem: Decodable, AccessibilityComponent, IdentifiableComponent {

    /// Id use to identifier the current component.
    public let id: String?

    /// Defines an image for your navigation bar.
    public let image: Image?

    /// Defines the text of the item.
    public let text: String

    /// Defines an action to be called when the item is clicked on.
    public let action: Action

    /// Defines Accessibility details for the item.
    public let accessibility: Accessibility?

    public init(
            id: String? = nil,
            image: Image? = nil,
            text: String,
            action: Action,
            accessibility: Accessibility? = nil
    ) {
        self.id = id
        self.image = image
        self.text = text
        self.action = action
        self.accessibility = accessibility
    }

    enum CodingKeys: String, CodingKey {
        case id
        case image
        case text
        case action
        case accessibility
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(String.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        action = try container.decode(forKey: .action)
        accessibility = try container.decodeIfPresent(Accessibility.self, forKey: .accessibility)
        image = try container.decodeIfPresent(Image.self, forKey: .image)
    }

}
