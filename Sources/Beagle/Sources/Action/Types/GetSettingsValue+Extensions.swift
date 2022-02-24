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

extension GetSettingsValue: AsyncAction {

    public func execute(controller: BeagleController, origin: UIView) {

        guard let keyEvaluated = key?.evaluate(with: origin) else {

            executeError(controller: controller, origin: origin, value: [
                "message": "Key cannot be empty."
            ])

            return
        }

        let value = UserDefaults.standard.string(forKey: keyEvaluated)
        
        executeSuccess(controller: controller, origin: origin, value: [
            "value": "\(value ?? "")"
        ])
    }

    func executeError(controller: BeagleController, origin: UIView, error: Error) {
        executeError(
                controller: controller,
                origin: origin,
                value: [
                    "message": "\(error.localizedDescription)"
                ]
        )
    }

    func executeError(controller: BeagleController, origin: UIView, value: DynamicObject) {
        DispatchQueue.main.async {
            controller.execute(actions: onError, with: "onError", and: value, origin: origin)
            controller.execute(actions: onFinish, event: "onFinish", origin: origin)
        }
    }

    func executeSuccess(controller: BeagleController, origin: UIView, value: DynamicObject) {
        DispatchQueue.main.async {
            controller.execute(actions: onSuccess, with: "onSuccess", and: value, origin: origin)
            controller.execute(actions: onFinish, event: "onFinish", origin: origin)
        }
    }
}
