//
// Created by calendia on 10/15/21.
// Copyright (c) 2021 Zup IT. All rights reserved.
//

import Foundation

extension While {
    public func execute(controller: BeagleController, origin: UIView) {

        guard let timeMilliseconds = timeInterval.evaluate(with: origin) else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(timeMilliseconds)) {
            let conditionValue = condition.evaluate(with: origin) ?? false

            if (conditionValue) {
                if let onTick = onTick {
                    controller.execute(actions: onTick, event: "onTick", origin: origin)
                }

                execute(controller: controller, origin: origin)

            } else {
                if let onFinish = onFinish {
                    controller.execute(actions: onFinish, event: "onFinish", origin: origin)
                }
            }
        }
    }
}
