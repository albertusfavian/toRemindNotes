//
//  NotesTVC.swift
//  toRemindNotes
//
//  Created by Mac-albert on 02/05/21.
//

import UIKit

class NotesTVC: UITableViewCell {

    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var tagLabel: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
