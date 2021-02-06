//
//  NewsCellTableViewCell.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit


let newsCellTableViewCell = "NewsCellTableViewCell"
typealias emptyBlock = (() -> Void)

class NewsCellTableViewCell: UITableViewCell {

    @IBOutlet weak var sourceNameLbl: UILabel!
    @IBOutlet weak var newsDescriptionLbl: UILabel!
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var bookmarkBtn: UIButton!

    var block: emptyBlock?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var items: Articles! {
        didSet {
            newsTitleLbl.text = items.title
            newsDescriptionLbl.text = items.description
            sourceNameLbl.text = items.source?.name
            if let url = URL(string: items.urlToImage ?? "") {
                newsImg.kf.indicatorType = .activity
                newsImg.kf.setImage(with: url)
            }
        }
    }

    var itemsForBookmark: [String: Any]! {
        didSet {
            newsTitleLbl.text = itemsForBookmark["title"] as? String
            newsDescriptionLbl.text = itemsForBookmark["description"] as? String
            sourceNameLbl.text = itemsForBookmark["sourceName"] as? String
            if let url = URL(string: itemsForBookmark["urlToImage"] as? String ?? "") {
                newsImg.kf.indicatorType = .activity
                newsImg.kf.setImage(with: url)
            }
            bookmarkBtn.setImage(UIImage(named: "bookmarkEnabled"), for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func bookmarkBtnAction(_ sender: Any) {
        block?()
    }
}
