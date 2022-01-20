// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

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

import PackageDescription

let package = Package(
        name: "Beagle",
        platforms: [
            .iOS(.v12)
        ],
        products: [
            .library(name: "Beagle", targets: ["Beagle"])
        ],
        dependencies: [
            .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "6.1.0"),
            .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "8.0.0"),
            .package(url: "https://github.com/ZupIT/yoga.git", from: "1.19.0"),
            .package(url: "https://github.com/Flipboard/FLAnimatedImage.git", from: "1.0.15"),
            .package(url: "https://github.com/maxep/MXParallaxHeader.git", branch: "master")
        ],
        targets: [
            .target(
                    name: "Beagle",
                    dependencies: [
                        .product(name: "YogaKit", package: "yoga")
                    ],
                    path: "Sources/Beagle",
                    exclude: ["BeagleTests"]
            )
        ]
)