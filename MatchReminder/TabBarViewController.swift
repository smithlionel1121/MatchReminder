//
//  TabBarViewController.swift
//  Match Reminder
//
//  Created by Lionel Smith on 20/08/2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fixtureViewController = UINavigationController(rootViewController: FixtureViewController())
        fixtureViewController.title = "Fixtures"
        
        self.setViewControllers([fixtureViewController], animated: false)
        
        guard let items = tabBar.items else { return }
        
        let images = ["calendar"]
        
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: images[i])
        }
    }
    
}

