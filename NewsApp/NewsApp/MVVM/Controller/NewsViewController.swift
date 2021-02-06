//
//  NewsControllerViewController.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit
import Kingfisher

class NewsViewController: UIViewController {

    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var sourceNameLbl: UILabel!
    @IBOutlet weak var bookmarkBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var viewModel: NewsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controllerDidLoad()
        registerCell()
        self.tableView.tableFooterView = UIView()
    }

}

extension NewsViewController {

    private func registerCell() {
        tableView.register(UINib.init(nibName: newsCellTableViewCell, bundle: nil),
                           forCellReuseIdentifier: newsCellTableViewCell)
    }


    private func setupData() {
        if let url = URL(string: viewModel.topNewsImg ?? "") {
            newsImg.kf.indicatorType = .activity
            newsImg.kf.setImage(with: url)
        }
        titleLbl.text = viewModel.topNewsTitle
        descriptionLbl.text = viewModel.topNewsDescription
        sourceNameLbl.text = viewModel.topNewsSourceName
    }

}

//MARK:- TableViewDelegate
extension NewsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellTableViewCell,
                                                 for: indexPath) as? NewsCellTableViewCell
        guard let data = viewModel.dataForRows(indexPath: indexPath) else {return UITableViewCell()}
        cell?.items = data
        cell?.block = { [weak self] in
            self?.viewModel.createBookmark(data: data)
        }
        return cell ?? UITableViewCell()
    }
}

//MARK:- IBAction

extension NewsViewController {

    @IBAction func bookMarkAction(_ sender: Any) {
        viewModel.createBookmark()
    }

    @IBAction func searchAction(_ sender: Any) {
        viewModel.moveToSearchScreen()
    }

    @IBAction func moveToBookMarkAction(_ sender: Any) {
        viewModel.moveToBookmarkScreen()
    }

}

//MARK:- view Model output

extension NewsViewController: NewsViewModelOutput {

    func reloadDataForTopNews() {
        setupData()
    }
    
    func reloadDataForPopularNews() {
        tableView.reloadData()
    }
    

    func showError(title: String?) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showActivityIndicator() {
        self.view.showDefaultActivityIndicator(shouldDisableUserInteraction: true)
    }

    func hideActivityIndicator() {
        self.view.hideDefaultActivityIndicator()
    }

}
