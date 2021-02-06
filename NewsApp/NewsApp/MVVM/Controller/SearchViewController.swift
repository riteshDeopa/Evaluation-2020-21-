//
//  SearchViewController.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var viewModel: SearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        viewModel.retrieveValue(key: .search)
        self.tableView.tableFooterView = UIView()
    }
}

extension SearchViewController {

    private func registerCell() {
        tableView.register(UINib.init(nibName: newsCellTableViewCell, bundle: nil),
                           forCellReuseIdentifier: newsCellTableViewCell)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text, text != "" {
            viewModel.saveValue(key: .search, text: text)
            searchBar.text?.removeAll()
        }
    }

}

//MARK:- TableViewDelegate
extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchTableViewCell,
                                                 for: indexPath) as? SearchTableViewCell
        guard let data = viewModel.dataForRows(indexPath: indexPath) else {
            return UITableViewCell()}
        cell?.searchTextLbl.text = data
        return cell ?? UITableViewCell()
    }
}

extension SearchViewController: SearchViewModelOutput {
    
    func reloadData() {
        tableView.reloadData()
    }

}
