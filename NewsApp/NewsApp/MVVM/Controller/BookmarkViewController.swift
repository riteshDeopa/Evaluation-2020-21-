//
//  BookMarkViewController.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit

class BookmarkViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var viewModel: BookmarkViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        self.tableView.tableFooterView = UIView()
        viewModel.controllerDidLoad()
    }
    
}

extension BookmarkViewController {
    private func registerCell() {
        tableView.register(UINib.init(nibName: newsCellTableViewCell, bundle: nil),
                           forCellReuseIdentifier: newsCellTableViewCell)
    }
}

extension BookmarkViewController {
    
    @IBAction func searchAction(_ sender: Any) {
        viewModel.moveToSearchScreen()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK:- TableViewDelegate
extension BookmarkViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellTableViewCell,
                                                 for: indexPath) as? NewsCellTableViewCell
        guard let data = viewModel.dataForRows(indexPath: indexPath) else {return UITableViewCell()}
        cell?.itemsForBookmark = data
        cell?.block = { [weak self] in
            let publishedAt = data["publishedAt"] as? String ?? ""
            self?.viewModel.removeData(text: publishedAt)
        }
        return cell ?? UITableViewCell()
    }
}

extension BookmarkViewController: BookmarkVMOutput {

    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

}
