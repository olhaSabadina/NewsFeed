//
//  NewsListViewController.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 12.12.2023.
//
import Combine
import UIKit
import GoogleMobileAds

class NewsListViewController: UIViewController {
    
    private let lineViewTop = UIView()
    private let newsTable = UITableView()
    private let closeButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView()
    private let refreshControl = UIRefreshControl()
    private let viewModel = NewsListViewModel()
    private var cancellable = Set<AnyCancellable>()
    var networkMonitor: NetworkMonitor?
    var multipleNativeAd: GADNativeAd?
    var banner = GADBannerView()
    
    //MARK: - life cycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setLineView()
        setNewsTable()
        setActivityIndicator()
        setGADBannerView()
        setConstraints()
        sinkToDataSourse()
        sinkToMonitor()
        sinkToLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAdManager.shared.delegateForNativeAd = self
        reloadTable()
    }
    
    //MARK: - private func:
    
    private func sinkToMonitor() {
        networkMonitor?.$isConnect
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { isConnect in
                if isConnect {
                    self.showAlert(typeConnection: .isConnected) { _ in
                        self.viewModel.fetchAllRssNews()
                    }
                } else {
                    self.showAlert(typeConnection: .disconnect, action: nil)
                }
            }
            .store(in: &cancellable)
    }
    
    private func sinkToDataSourse() {
        viewModel.$channels
            .dropFirst()
            .sink { _ in
                self.reloadTable()
            }
            .store(in: &cancellable)
    }
    
    private func sinkToLoading() {
        viewModel.$isLoading
            .sink { isLoading in
                switch isLoading {
                case true:
                    self.activityIndicator.startAnimating()
                case false:
                    self.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellable)
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.newsTable.reloadData()
        }
    }
    
    private func setActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        activityIndicator.style = .large
        view.addSubview(activityIndicator)
    }
    
    private func setGADBannerView() {
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.rootViewController = self
        banner.load(GADRequest())
        banner.backgroundColor = .clear
    
        closeButton.setImage(ImageConstants.close, for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeBanner), for: .touchUpInside)
        
        banner.addSubview(closeButton)
        banner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(banner)
        banner.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.banner.isHidden = false
        }
    }
    
    @objc private func closeBanner() {
        banner.removeFromSuperview()
    }
    
    
    @objc private func refreshTable() {
        viewModel.fetchAllRssNews()
        refreshControl.endRefreshing()
    }
    
    // MARK: - constraints:
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            lineViewTop.topAnchor.constraint(equalTo: navigationItem.titleView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor),
            lineViewTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineViewTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            newsTable.topAnchor.constraint(equalTo: lineViewTop.bottomAnchor),
            newsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            banner.heightAnchor.constraint(equalToConstant: 60),
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            banner.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            closeButton.trailingAnchor.constraint(equalTo: banner.trailingAnchor, constant: -5),
            closeButton.topAnchor.constraint(equalTo: banner.topAnchor)
        ])
        
    }
    
    private func showAlert(typeConnection: InternetConnectionType, action: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "Attention", message: typeConnection.message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        let okAction = UIAlertAction(title: "Refresh", style: .default, handler: action)
        if typeConnection == .isConnected {
            alert.addAction(okAction)
        }
        self.present(alert, animated: true)
    }
    
}

// MARK: - Table delegate, dataSource:

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberRowsData = viewModel.numberOfItemsInSection()
        let adGoogleRows = viewModel.numberOfItemsInSection() / 10
        return numberRowsData + adGoogleRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 10 == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AdGoogleCell.cellID, for: indexPath) as? AdGoogleCell else { return UITableViewCell()}
           
            for subView in cell.subviews {
                subView.removeFromSuperview()
            }
            
            if let nativeAd = multipleNativeAd {
                if let adView = cell.setNativeADDView() {
                GoogleAdManager.shared.displayNativeAd(nativeAd: nativeAd, nativeAdView: adView)
                }
            } else {
                GoogleAdManager.shared.requestForNativeAdd(rootVC: self)
            }
            return cell
            
        } else {
            let contentIndex = indexPath.row - indexPath.row / 10
            let rssItem = viewModel.channels[contentIndex]
            
            switch rssItem.typeCell {
                
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCellShort.cellID, for: indexPath) as? NewsCellShort else { return UITableViewCell()}
                cell.newsModel = rssItem
                cell.delegate = self
                return cell
                
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCellFull.cellID, for: indexPath) as? NewsCellFull else { return UITableViewCell()}
                cell.newsModel = rssItem
                cell.delegate = self
                return cell
                
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCellMedium.cellID, for: indexPath) as? NewsCellMedium else { return UITableViewCell()}
                cell.newsModel = rssItem
                cell.delegate = self
                return cell
                
            default: return UITableViewCell()
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? BaseCell,
              let model = cell.newsModel
        else { return }
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        navigationController?.pushViewController(NewsReadViewController(rssModel: model), animated: true)
    }
}

//MARK: - setView elements:

extension NewsListViewController {
    
    private func configureView() {
        view.backgroundColor = .customBackground
        navigationItem.title = TitleConstants.homeVC
        setUpNavBarColor()
    }
    
    private func setLineView() {
        lineViewTop.backgroundColor = .systemGray6
        lineViewTop.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineViewTop.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineViewTop)
    }
    
    private func setNewsTable() {
        newsTable.register(AdGoogleCell.self, forCellReuseIdentifier: AdGoogleCell.cellID)
        newsTable.register(NewsCellShort.self, forCellReuseIdentifier: NewsCellShort.cellID)
        newsTable.register(NewsCellFull.self, forCellReuseIdentifier: NewsCellFull.cellID)
        newsTable.register(NewsCellMedium.self, forCellReuseIdentifier: NewsCellMedium.cellID)
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        newsTable.backgroundColor = .customBackground
        newsTable.dataSource = self
        newsTable.delegate = self
        newsTable.separatorStyle = .none
        newsTable.showsVerticalScrollIndicator = false
        newsTable.translatesAutoresizingMaskIntoConstraints = false
        newsTable.refreshControl = refreshControl
        newsTable.refreshControl?.tintColor = .white
        view.addSubview(newsTable)
    }
}

extension NewsListViewController: BaseCellDelegate {
    
    func didTapButtonInCell(_ cell: BaseCell) {
        guard let item = cell.newsModel else { return }
        CoreDataManager.instance.addToFavorites(item)
        reloadTable()
    }
}

extension NewsListViewController: NativeAdProtocol {
    func nativeAdLoader(ad: GADNativeAd) {
        multipleNativeAd = ad
        reloadTable()
    }
    
    func failToLoadNativeAd() {
        print("Fail load Native Ad")
    }
}
