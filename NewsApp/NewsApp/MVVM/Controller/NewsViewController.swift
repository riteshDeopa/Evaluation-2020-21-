//
//  NewsControllerViewController.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var sourceNameLbl: UILabel!
    @IBOutlet weak var bookmarkBtn: UIButton!

    var viewModel: NewsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controllerDidLoad()
    }

}



//MARK:- IBAction

extension NewsViewController {
    
    @IBAction func bookMarkAction(_ sender: Any) {
    }
    
}

//MARK:- view Model output

extension NewsViewController: NewsViewModelOutput {

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

    func reloadData() {
        
    }
}
