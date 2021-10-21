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

extension RemoveChildren {
    public func execute(controller: BeagleController, origin: UIView) {
        guard let view = controller.view.getView(by: componentId) else { return }

        view.subviews.indices.forEach { index in
            if(self.index == index) {
                view.subviews[index].removeFromSuperview()
            }
        }
    }
}

private extension UIView {
    func getView(by id: String) -> UIView? {
        if accessibilityIdentifier == id {
            return self
        }
        for view in subviews {
            if let view = view.getView(by: id) {
                return view
            }
        }
        return nil
    }
}
