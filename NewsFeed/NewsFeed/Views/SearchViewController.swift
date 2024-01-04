//
//  SearchViewController.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 12.12.2023.
//

import UIKit

class SearchViewController: UIViewController {

    private let lineViewTop = UIView()
    private let searchController = UISearchController()
    private let searchTable = UITableView()
    private let vm = SearchViewModel()

    //MARK: - life cycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setLineView()
        setupSearchController()
        setSearchTable()
        setConstraints()
    }
    
    //MARK: - private func:
    
    private func configureView() {
        view.backgroundColor = .customBackground
        navigationItem.title = TitleConstants.searchVC
        setUpNavBarColor()
    }
    
    private func setLineView() {
            lineViewTop.backgroundColor = .systemGray6
            lineViewTop.heightAnchor.constraint(equalToConstant: 1).isActive = true
            lineViewTop.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(lineViewTop)
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.searchTextField.backgroundColor = .secondarySystemBackground
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.delegate = self
    }
    
    private func setSearchTable() {
        searchTable.register(SmallNewsCell.self, forCellReuseIdentifier: SmallNewsCell.cellID)
        searchTable.backgroundColor = .clear
        searchTable.dataSource = self
        searchTable.delegate = self
        searchTable.separatorStyle = .none
        searchTable.showsVerticalScrollIndicator = false
        searchTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTable)
    }
    
    // MARK: - constraints:
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            lineViewTop.topAnchor.constraint(equalTo: navigationItem.titleView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor),
            lineViewTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineViewTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            searchTable.topAnchor.constraint(equalTo: lineViewTop.bottomAnchor),
            searchTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110)
        ])
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.numberOfItemsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SmallNewsCell.cellID, for: indexPath) as? SmallNewsCell else { return UITableViewCell()}
        cell.newsModel = vm.cellConfigure(indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? BaseCell,
              let model = cell.newsModel
        else { return }
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        navigationController?.pushViewController(NewsReadViewController(rssModel: model), animated: true)
    }
}

extension SearchViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterContentForSearchText("")
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if searchText.count >= 1 {
            vm.setupFetchResultController(search: searchText)
        } else{
            vm.setupFetchResultController(search: "")
        }
        searchTable.reloadData()
    }
}

extension SearchViewController: BaseCellDelegate {
    
    func didTapButtonInCell(_ cell: BaseCell) {
        guard let item = cell.newsModel else { return }
        CoreDataManager.instance.addToFavorites(item)
    }
}
