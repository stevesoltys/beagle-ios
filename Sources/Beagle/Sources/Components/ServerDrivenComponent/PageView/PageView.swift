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

/// The PageView component is a specialized container to hold pages (views) that will be displayed horizontally.
public struct PageView: ServerDrivenComponent, Decodable, HasContext {

    /// Defines a List of components (views) that are contained on this PageView.
    public let children: [ServerDrivenComponent]?

    /// Defines in what page the PageView is currently on.
    public let pageIndicator: PageIndicatorComponent?

    /// Defines the contextData that be set to pageView.
    public let context: Context?

    /// List of actions that are performed when you are on the selected page.
    public let onPageChange: [Action]?

    /// Integer number that identifies that selected.
    public let currentPage: Expression<Int>?

    /// Flag indicating whether or not page transitions are animated.
    public let animated: Bool?

    /// Flag indicating whether or not scrolling between pages is enabled.
    public let scrollable: Bool?

    @available(*, deprecated, message: "If you want to use page indicator place it as a separate component and comunicate then using context.")
    public init(
            children: [ServerDrivenComponent]? = nil,
            pageIndicator: PageIndicatorComponent? = nil,
            context: Context? = nil,
            onPageChange: [Action]? = nil,
            currentPage: Expression<Int>? = nil,
            animated: Bool? = nil,
            scrollable: Bool? = nil
    ) {
        self.children = children
        self.pageIndicator = pageIndicator
        self.context = context
        self.onPageChange = onPageChange
        self.currentPage = currentPage
        self.animated = animated
        self.scrollable = scrollable
    }

    public init(
            children: [ServerDrivenComponent]? = nil,
            context: Context? = nil,
            onPageChange: [Action]? = nil,
            currentPage: Expression<Int>? = nil,
            animated: Bool? = nil,
            scrollable: Bool? = nil
    ) {
        self.children = children
        self.pageIndicator = nil
        self.context = context
        self.onPageChange = onPageChange
        self.currentPage = currentPage
        self.animated = animated
        self.scrollable = scrollable
    }

    #if swift(<5.3)
public init(
context: Context? = nil,
onPageChange: [Action]? = nil,
currentPage: Expression<Int>? = nil,
@ChildBuilder
_ children: () -> ServerDrivenComponent
) {
self.init(children: [children()], context: context, onPageChange: onPageChange, currentPage: currentPage,
animated: nil, scrollable: nil)
}
    #endif

    public init(
            context: Context? = nil,
            onPageChange: [Action]? = nil,
            currentPage: Expression<Int>? = nil,
            @ChildrenBuilder
            _ children: () -> [ServerDrivenComponent]
    ) {
        self.init(children: children(), context: context, onPageChange: onPageChange, currentPage: currentPage,
                animated: nil, scrollable: nil)
    }
    
    enum CodingKeys: String, CodingKey {
        case children
        case pageIndicator
        case context
        case onPageChange
        case currentPage
        case animated
        case scrollable
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        children = try container.decodeIfPresent(forKey: .children)
        let rawPageIndicator: ServerDrivenComponent? = try container.decodeIfPresent(forKey: .pageIndicator)
        pageIndicator = rawPageIndicator as? PageIndicatorComponent
        context = try container.decodeIfPresent(Context.self, forKey: .context)
        onPageChange = try container.decodeIfPresent(forKey: .onPageChange)
        currentPage = try container.decodeIfPresent(Expression<Int>.self, forKey: .currentPage)
        animated = try container.decodeIfPresent(Bool.self, forKey: .animated)
        scrollable = try container.decodeIfPresent(Bool.self, forKey: .scrollable)
    }
}

@available(*, deprecated, message: "This will be removed in a future version; please refactor this component using new context features.")
public protocol PageIndicatorComponent: ServerDrivenComponent {}
