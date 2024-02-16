//
//  AnimationHelper.swift
//  MovieDBExample
//
//  Created by Suleman Ali on 16/02/2024.
//

import Foundation
import UIKit
import Hero


extension UIViewController {
    func enableHero() {
        self.isHeroEnabled = true
        self.navigationController?.isHeroEnabled = true
    }
    func disableHero() {
        self.navigationController?.isHeroEnabled = false
    }

    func showHero(_ viewController:UIViewController,navigationAnimationType:HeroDefaultAnimationType = .autoReverse(presenting:.zoom)) {
        viewController.hero.isEnabled = true
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = navigationAnimationType
        navigationController?.pushViewController(viewController, animated: true)

    }
}

extension UINavigationController {
    func show(_ viewController:UIViewController,navigationAnimationType:HeroDefaultAnimationType = .autoReverse(presenting:.zoom)) {
        viewController.hero.isEnabled = true
        hero.isEnabled = true
        hero.navigationAnimationType = navigationAnimationType
        pushViewController(viewController, animated: true)

    }
}
