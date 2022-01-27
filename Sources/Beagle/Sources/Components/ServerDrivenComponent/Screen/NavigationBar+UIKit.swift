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

extension NavigationBarItem {

    func toBarButtonItem(
            controller: BeagleScreenViewController
    ) -> UIBarButtonItem {
        return NavigationBarButtonItem(barItem: self, controller: controller)
    }

    final private class NavigationBarButtonItem: UIBarButtonItem {

        private let barItem: NavigationBarItem
        private weak var controller: BeagleScreenViewController?

        init(
                barItem: NavigationBarItem,
                controller: BeagleScreenViewController
        ) {
            self.barItem = barItem
            self.controller = controller
            super.init()

            target = self
            action = #selector(triggerAction)

            if let barItemImage = barItem.image {
                handleContextOnNavigationBarImage(barItemImage: barItemImage)
                accessibilityHint = barItem.text
            } else {
                title = barItem.text
            }

            accessibilityIdentifier = barItem.id
            ViewConfigurator.applyAccessibility(barItem.accessibility, to: self)
        }

        private func handleContextOnNavigationBarImage(barItemImage: Image) {
            let imageView = barItemImage.toView(renderer: controller!.renderer)
            imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)

            let tap: UITapGestureRecognizer = UITapGestureRecognizer(
                    target: self,
                    action: action
            )

            tap.cancelsTouchesInView = false
            imageView.addGestureRecognizer(tap)

            self.customView = imageView
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc private func triggerAction() {
            if case .view(let view) = controller?.content {
                controller?.execute(actions: [barItem.action], event: nil, origin: view)
            }
        }
    }
}

public class NavigationBarSearchUpdater: NSObject, UISearchResultsUpdating {
    
    private let controller: BeagleController

    private let onQueryUpdated: [Action]?
    
    private var lastQuery: String? = nil
    
    init(controller: BeagleController, onQueryUpdated: [Action]?) {
        self.controller = controller
        self.onQueryUpdated = onQueryUpdated
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        if let onQueryUpdated = onQueryUpdated {
            let query = searchController.searchBar.text ?? ""
            
            if(lastQuery != query) {
                let value: DynamicObject = [
                    "query": "\(query)"
                ]
                
                controller.execute(actions: onQueryUpdated, with: "onQueryUpdated",
                                   and: value, origin: searchController.searchBar)
                
                lastQuery = query
            }
        }
    }
}
