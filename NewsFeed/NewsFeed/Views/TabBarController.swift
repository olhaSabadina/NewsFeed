//
//  TabBarViewController.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 12.12.2023.
//
import Combine
import UIKit

class TabBarController: UITabBarController {
    
    private let lineViewBottom = UIView()
    private let networkMonitor: NetworkMonitor
    private var cancellable = Set<AnyCancellable>()
    
    init(networkMonitor: NetworkMonitor) {
        self.networkMonitor = networkMonitor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - life cycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setLineView()
        setConstraints()
    }
    //MARK: - private func:
    
    private func generateTabBar() {
        let vc = NewsListViewController()
        vc.networkMonitor = networkMonitor
        let homeViewController = UINavigationController(rootViewController: vc)
        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        let bellViewController = UINavigationController(rootViewController: BellViewController())
        let savedViewController = UINavigationController(rootViewController: SavedViewController())

        viewControllers = [
            generateVC(viewController: homeViewController, image: ImageConstants.house),
            generateVC(viewController: searchViewController, image: ImageConstants.magnifyingglass),
            generateVC(viewController: bellViewController, image: ImageConstants.bell),
            generateVC(viewController: savedViewController, image: ImageConstants.bookmark),
            ]
    }
    
    private func generateVC(viewController: UINavigationController, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.image = image
        tabBar.unselectedItemTintColor = UIColor.white
        tabBar.tintColor = .red
        return viewController
    }
    
    private func setLineView() {
        lineViewBottom.backgroundColor = .systemGray6
        lineViewBottom.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineViewBottom.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineViewBottom)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            lineViewBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineViewBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineViewBottom.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -10)
        ])
    }
}

