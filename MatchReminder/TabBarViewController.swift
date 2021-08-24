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
        fixtureViewController.tabBarItem = UITabBarItem(title: "Fixtures", image: UIImage(systemName: "calendar"), selectedImage: nil)
        
        let standingsViewController = UINavigationController(rootViewController: StandingsViewController())
        standingsViewController.tabBarItem = UITabBarItem(title: "Standings", image: UIImage(systemName: "list.number"), selectedImage: nil)
        
        self.setViewControllers([fixtureViewController, standingsViewController], animated: false)

    }
    
}

