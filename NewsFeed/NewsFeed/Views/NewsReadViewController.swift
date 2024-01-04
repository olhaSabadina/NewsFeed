//
//  NewsReadViewController.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 13.12.2023.
//

import UIKit
import WebKit

class NewsReadViewController: UIViewController {
    
    private let lineViewTop = UIView()
    private let webView = WKWebView()
    private let backButton = UIButton(type: .system)
    let bookmarkButton = UIButton(type: .system)
    let channelLabel = UILabel()
    let rssModel: RssItem
   
    init(rssModel: RssItem) {
        self.rssModel = rssModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        webViewLoadURL(urlAdress: rssModel.urlLink)
        setLineView()
        setBackNavigationButton()
        setBookmarkButton()
        setChannelLabels()
        setWebView()
        setConstraints()
        
    }
    
    private func webViewLoadURL(urlAdress: String?) {
            guard let urlLink = urlAdress,
                    let url = URL(string: urlLink) else {return}
            self.webView.load(URLRequest(url: url))
    }
    
    //MARK: - @objc func:
    
    @objc func backToHomeVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addToSaved() {
        CoreDataManager.instance.addToFavorites(rssModel)
    }
    
    // MARK: - constraints:
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            lineViewTop.topAnchor.constraint(equalTo: navigationItem.titleView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor),
            lineViewTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineViewTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            channelLabel.topAnchor.constraint(equalTo: lineViewTop.topAnchor, constant: 5),
            channelLabel.heightAnchor.constraint(equalToConstant: 30),
            channelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            channelLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            webView.topAnchor.constraint(equalTo: channelLabel.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -100),
        ])
    }
}

//MARK: - setView elements:

extension NewsReadViewController: WKNavigationDelegate {
    
    private func configureView() {
        view.backgroundColor = .customBackground
        configureChannelName()
        title = rssModel.nameChannel?.firstThreewords()
        setUpNavBarColor()
    }
    
    private func setLineView() {
            lineViewTop.backgroundColor = .systemGray6
            lineViewTop.heightAnchor.constraint(equalToConstant: 1).isActive = true
            lineViewTop.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(lineViewTop)
    }
    
    private func setBackNavigationButton() {
        backButton.frame = .init(x: 0, y: 0, width: 20, height: 20)
        backButton.setImage(ImageConstants.back, for: .normal)
        backButton.tintColor = .systemGray6
        backButton.addTarget(self, action: #selector(backToHomeVC), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setBookmarkButton() {
        bookmarkButton.frame = .init(x: 0, y: 0, width: 20, height: 20)
        bookmarkButton.setImage(ImageConstants.bookmark, for: .normal)
        bookmarkButton.tintColor = .systemGray6
        bookmarkButton.addTarget(self, action: #selector(addToSaved), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarkButton)
    }
    
    private func configureChannelName() {
        var string = "\(rssModel.nameChannel?.firstThreewords() ?? "") , "
        string.append(rssModel.pubDate?.differenceDate() ?? "")
        channelLabel.text = string
    }
    
    private func setChannelLabels() {
        
        channelLabel.font = .systemFont(ofSize: 14)
        channelLabel.textColor = .systemGray6
        channelLabel.textAlignment = .left
        channelLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(channelLabel)
    }
    
    private func setWebView() {
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
    }
}
