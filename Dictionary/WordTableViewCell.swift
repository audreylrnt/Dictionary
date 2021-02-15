//
//  WordTableViewCell.swift
//  Dictionary
//
//  Created by Laurentia Audrey on 14/02/21.
//  Copyright © 2021 Laurentia Audrey. All rights reserved.
//
 
import UIKit

class WordTableViewCell: UITableViewCell {
    @IBOutlet weak var dcImage: UIImageView!
    @IBOutlet weak var dcType: UILabel!
    @IBOutlet weak var dcDesc: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
