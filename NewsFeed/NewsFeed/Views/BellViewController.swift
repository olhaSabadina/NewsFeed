//
//  BellViewController.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 12.12.2023.
//

import UIKit

class BellViewController: UIViewController {

    let lineViewTop = UIView()
  
    //MARK: - life cycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setLineView()
        setConstraints()
    }
    
    //MARK: - private func:
    
    private func configureView() {
        view.backgroundColor = .customBackground
        navigationItem.title = TitleConstants.reminedVC
        setUpNavBarColor()
    }
    
    private func setLineView() {
            lineViewTop.backgroundColor = .systemGray6
            lineViewTop.heightAnchor.constraint(equalToConstant: 1).isActive = true
            lineViewTop.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(lineViewTop)
    }
    
    // MARK: - constraints:
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            lineViewTop.topAnchor.constraint(equalTo: navigationItem.titleView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor),
            lineViewTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineViewTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
