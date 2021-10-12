//
// Created by calendia on 10/12/21.
// Copyright (c) 2021 Zup IT. All rights reserved.
//

import Foundation

public struct NavigationBarStyle: Decodable {

    public var backgroundColor: String?

    public var textColor: String?

    public var textSize: Int?

    public var tintColor: String?

    public var isShadowEnabled: Bool?

    public var isTransparent: Bool?

    public var titleImage: Image?

    public init(
            backgroundColor: String? = nil,
            textColor: String? = nil,
            textSize: Int? = nil,
            tintColor: String? = nil,
            isShadowEnabled: Bool? = nil,
            isTransparent: Bool? = nil,
            titleImage: Image? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.textSize = textSize
        self.tintColor = tintColor
        self.isShadowEnabled = isShadowEnabled
        self.isTransparent = isTransparent
        self.titleImage = titleImage
    }
}