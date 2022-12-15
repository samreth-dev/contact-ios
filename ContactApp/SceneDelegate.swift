//
//  SceneDelegate.swift
//  ContactApp
//
//  Created by Samreth Kem on 12/4/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let homeViewControllerViewModel = HomeViewControllerViewModel(reloadToggle: false, contactsForDeleting: [], contacts: [], isEdit: false, cancellable: [])
        
        let homeViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewController.viewModel = homeViewControllerViewModel
        
        let navigationController = UINavigationController(rootViewController: homeViewController)
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

