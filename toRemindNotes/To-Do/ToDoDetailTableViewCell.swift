//
//  ToDoDetailTableViewCell.swift
//  toRemindNotes
//
//  Created by Mac-albert on 03/05/21.
//

import UIKit

protocol sendDatatoCoreData {
    func sendImageDidTap(myData: String)
}
class ToDoDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var buttonImage: UIButton!
    var delegate: sendDatatoCoreData? = nil
    var imageName: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func passData(Data: String){
        self.delegate?.sendImageDidTap(myData: imageName)
    }
    
//    @IBAction func imageDidTap(){
//        noteList    }
}
