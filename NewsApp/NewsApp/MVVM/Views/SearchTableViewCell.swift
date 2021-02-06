//
//  SearchTableViewCell.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit

let searchTableViewCell = "SearchTableViewCell"

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchTextLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
