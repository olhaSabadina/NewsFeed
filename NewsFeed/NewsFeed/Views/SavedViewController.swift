//
//  SavedViewController.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 12.12.2023.
//

import UIKit
import Combine
import CoreData

class SavedViewController: UIViewController {

    private let lineViewTop = UIView()
    private let savedNewsTable = UITableView()
    private let vm = SavedVCViewModel()
    private var cancellable = Set<AnyCancellable>()

    //MARK: - life cycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setLineView()
        setSavedNewsTable()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try vm.fetchResultController.performFetch()
        } catch {
            print(error)
        }
    }
    
    // MARK: - constraints:
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            lineViewTop.topAnchor.constraint(equalTo: navigationItem.titleView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor),
            lineViewTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineViewTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            savedNewsTable.topAnchor.constraint(equalTo: lineViewTop.bottomAnchor),
            savedNewsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            savedNewsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            savedNewsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110),
        ])
    }
}

// MARK: - Table delegate, dataSource:

extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        guard let cell = tableView.cellForRow(at: indexPath) as? SmallNewsCell,
              let model = cell.newsModel
        else { return }
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        navigationController?.pushViewController(NewsReadViewController(rssModel: model), animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let cell = tableView.cellForRow(at: indexPath) as? SmallNewsCell else { return }
            vm.removeFromFavourites(cell.newsModel)
        }
    }
}

//MARK: - setView elements:

extension SavedViewController {
    
    private func configureView() {
        view.backgroundColor = .customBackground
        navigationItem.title = TitleConstants.savedVC
        vm.fetchResultController.delegate = self
        setUpNavBarColor()
    }
    
    private func setLineView() {
        lineViewTop.backgroundColor = .systemGray6
        lineViewTop.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineViewTop.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineViewTop)
    }
    
    private func setSavedNewsTable() {
        savedNewsTable.register(SmallNewsCell.self, forCellReuseIdentifier: SmallNewsCell.cellID)
        savedNewsTable.backgroundColor = .customBackground
        savedNewsTable.dataSource = self
        savedNewsTable.delegate = self
        savedNewsTable.separatorStyle = .none
        savedNewsTable.showsVerticalScrollIndicator = false
        savedNewsTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(savedNewsTable)
    }
}

extension SavedViewController: BaseCellDelegate {
    func didTapButtonInCell(_ cell: BaseCell) {
        vm.removeFromFavourites(cell.newsModel)
    }
}

//MARK: - Core Data Controller Configuration

extension SavedViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        savedNewsTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        savedNewsTable.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert :
            if let indexPath = newIndexPath {
                savedNewsTable.insertRows(at: [indexPath], with: .automatic)
            }
        case .update :
            if let indexPath = indexPath {
                savedNewsTable.reloadRows(at: [indexPath], with: .automatic)
            }
        case .delete :
            if let indexPath = indexPath {
                savedNewsTable.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move :
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                savedNewsTable.moveRow(at: indexPath, to: newIndexPath)
            }
        default : savedNewsTable.reloadData()
        }
    }
}
