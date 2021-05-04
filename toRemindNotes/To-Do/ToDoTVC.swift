//
//  ToDoTVC.swift
//  toRemindNotes
//
//  Created by Mac-albert on 03/05/21.
//

import UIKit

class ToDoTVC: UITableViewCell {

    
    @IBOutlet weak var addReminderLabel: UILabel!
    @IBOutlet weak var dateResultLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var switchReminder: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
