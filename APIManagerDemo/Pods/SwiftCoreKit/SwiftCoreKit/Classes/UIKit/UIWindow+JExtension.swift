//
//  UIWindow+JExtension.swift
//  JianxiaozhiAI
//
//  Created by Jie on 2020/9/29.
//  Copyright © 2020 Jie. All rights reserved.
//

import Foundation
import UIKit

public extension UIWindow {
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        if let presented = top?.presentedViewController {
            top = presented
        }
        if let tab = top as? UITabBarController {
            top = tab.selectedViewController
        }
        if let nav = top as? UINavigationController {
            top = nav.topViewController
        }
        return top
    }
}
