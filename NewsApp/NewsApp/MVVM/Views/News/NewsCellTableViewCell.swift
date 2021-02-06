//
//  NewsCellTableViewCell.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit

class NewsCellTableViewCell: UITableViewCell {

    @IBOutlet weak var sourceNameLbl: UILabel!
    @IBOutlet weak var newsDescriptionLbl: UILabel!
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func bookmarkBtnAction(_ sender: Any) {
    }
}
