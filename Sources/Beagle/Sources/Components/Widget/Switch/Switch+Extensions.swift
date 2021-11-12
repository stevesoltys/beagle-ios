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

extension Switch {

    public func toView(renderer: BeagleRenderer) -> UIView {
        let button = BeagleUISwitch(
                onPress: onPress,
                clickAnalyticsEvent: clickAnalyticsEvent,
                controller: renderer.controller
        )

        renderer.observe(enabled, andUpdateManyIn: button) {
            if let enabled = $0 {
                button.setOn(enabled, animated: true)
            }
        }

        renderer.observe(color, andUpdateManyIn: button) {
            button.onTintColor = $0.flatMap { UIColor(hex: $0) }
        }

        let preFetchHelper = renderer.dependencies.preFetchHelper
        onPress?
                .compactMap {
                    ($0 as? Navigate)?.newPath
                }
                .forEach {
                    preFetchHelper.prefetchComponent(newPath: $0)
                }

        if let styleId = styleId {
            button.styleId = styleId
        }

        return button
    }

    final class BeagleUISwitch: UISwitch {

        var styleId: String? {
            didSet {
                applyStyle()
            }
        }

        private var onPress: [Action]?
        private var clickAnalyticsEvent: AnalyticsClick?
        private weak var controller: BeagleController?

        required init(
                onPress: [Action]?,
                clickAnalyticsEvent: AnalyticsClick? = nil,
                controller: BeagleController?
        ) {
            super.init(frame: .zero)
            self.onPress = onPress
            self.clickAnalyticsEvent = clickAnalyticsEvent
            self.controller = controller
            self.addTarget(self, action: #selector(triggerTouchUpInsideActions), for: .touchUpInside)
        }

        @available(*, unavailable)
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            applyStyle()
        }

        @objc func triggerTouchUpInsideActions() {
            controller?.execute(actions: onPress, event: "onPress", origin: self)

            if let click = clickAnalyticsEvent {
                controller?.dependencies.analytics?.trackEventOnClick(click)
            }
        }

        private func applyStyle() {
            guard let styleId = styleId else {
                return
            }
            beagle.applyStyle(for: self as UISwitch, styleId: styleId, with: controller)
        }
    }
}
