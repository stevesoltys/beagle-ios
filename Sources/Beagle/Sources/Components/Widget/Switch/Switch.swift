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

/// Defines a switch natively using the server driven information received through Beagle.
public struct Switch: Widget, ClickedOnComponent, AutoDecodable {

    /// Defines the switch color.
    public let color: Expression<String>?

    /// References a native style configured to be applied on this switch.
    public let styleId: String?
    
    /// Attribute to define actions when this component is pressed.
    public let onPress: [Action]?
    
    /// Enables or disables the switch.
    public let enabled: Expression<Bool>?
    
    @available(*, deprecated, message: "Since version 1.6, a new infrastructure for analytics (Analytics 2.0) was provided, for more info check https://docs.usebeagle.io/v1.9/resources/analytics/")
    /// Attribute to define click event name.
    public var clickAnalyticsEvent: AnalyticsClick?
    
    /// Properties that all widgets have in common.
    public var widgetProperties: WidgetProperties

    @available(*, deprecated, message: "Since version 1.6, a new infrastructure for analytics (Analytics 2.0) was provided, for more info check https://docs.usebeagle.io/v1.9/resources/analytics/")
    public init(
        color: Expression<String>? = nil,
        styleId: String? = nil,
        onPress: [Action]? = nil,
        enabled: Expression<Bool>? = nil,
        clickAnalyticsEvent: AnalyticsClick,
        widgetProperties: WidgetProperties = WidgetProperties()
    ) {
        self.color = color
        self.styleId = styleId
        self.onPress = onPress
        self.enabled = enabled
        self.clickAnalyticsEvent = clickAnalyticsEvent
        self.widgetProperties = widgetProperties
    }
// sourcery:end
    
    public init(
        color: Expression<String>? = nil,
        styleId: String? = nil,
        onPress: [Action]? = nil,
        enabled: Expression<Bool>? = nil,
        widgetProperties: WidgetProperties = WidgetProperties()
    ) {
        self.color = color
        self.styleId = styleId
        self.onPress = onPress
        self.enabled = enabled
        self.widgetProperties = widgetProperties
    }
}
