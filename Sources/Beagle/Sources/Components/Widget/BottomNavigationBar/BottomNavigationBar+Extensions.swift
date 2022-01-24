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

fileprivate var navigationDelegate : MainTabBarViewController? = nil

extension BottomNavigationBar {
    
    public func toView(renderer: BeagleRenderer) -> UIView {
        let tabBar = UITabBar()

        renderer.observe(barTintColor, andUpdateManyIn: tabBar) { value in
            guard let value = value else {
                return
            }

            tabBar.barTintColor = UIColor(hex: value)
        }

        renderer.observe(tintColor, andUpdateManyIn: tabBar) { value in
            guard let value = value else {
                return
            }

            tabBar.tintColor = UIColor(hex: value)
        }
        
        navigationDelegate = MainTabBarViewController()
        navigationDelegate!.beagleController = renderer.controller
        navigationDelegate!.onTabSelection = onTabSelection
        
        tabBar.delegate = navigationDelegate
        

        tabBar.items = items.map { item in
            mapTabBarItem(renderer: renderer, item: item)
        }

        renderer.observe(currentTab, andUpdateManyIn: tabBar) { value in
            guard let value = value else {
                return
            }

            tabBar.selectedItem = tabBar.items![value]
        }

        return tabBar
    }

    private func mapTabBarItem(renderer: BeagleRenderer, item: BottomNavigationBarItem) -> UITabBarItem {
        let unselectedIconPath = item.unselectedIconPath.evaluate(with: nil) ?? ""
        let selectedIconPath = item.selectedIconPath.evaluate(with: nil) ?? ""

        let item = UITabBarItem(
                title: item.title ?? nil,
                image: nil,
                selectedImage: nil
        )

        updateIcon(unselected: true, tabBarItem: item, url: unselectedIconPath, renderer: renderer)
        updateIcon(unselected: false, tabBarItem: item, url: selectedIconPath, renderer: renderer)
        return item
    }

    private func updateIcon(unselected: Bool, tabBarItem: UITabBarItem, url: String, renderer: BeagleRenderer) {
        let controller = renderer.controller

        renderer.dependencies.imageDownloader.fetchImage(url: url, additionalData: nil) { result in
            switch result {

            case .success(let data):
                if (unselected) {
                    tabBarItem.image = UIImage(data: data)

                } else {
                    tabBarItem.selectedImage = UIImage(data: data)
                }

            case .failure:
                break
            }
        }
    }
}

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    public var beagleController: BeagleController? = nil

    public var onTabSelection: [Action]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items?.firstIndex { $0 === item }
        
        beagleController?.execute(actions: onTabSelection, with: "onTabSelection", and: ["index": .int(index!)], origin: tabBar)
    }
}
