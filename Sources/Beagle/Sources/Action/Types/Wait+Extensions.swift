//
// Created by calendia on 10/15/21.
// Copyright (c) 2021 Zup IT. All rights reserved.
//

import Foundation

extension Wait {
    public func execute(controller: BeagleController, origin: UIView) {

        guard let timeMilliseconds = time.evaluate(with: origin) else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(timeMilliseconds)) {
            if let onFinish = self.onFinish {
                controller.execute(actions: onFinish, event: "onFinish", origin: origin)
            }
        }
    }
}
