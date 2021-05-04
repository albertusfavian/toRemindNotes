//
//  ToDoDetailTableViewCell.swift
//  toRemindNotes
//
//  Created by Mac-albert on 03/05/21.
//

import UIKit

class ToDoDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
