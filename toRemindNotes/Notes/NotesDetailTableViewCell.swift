//
//  NotesDetailTableViewCell.swift
//  toRemindNotes
//
//  Created by Mac-albert on 01/05/21.
//

import UIKit

protocol MyDataSendingDelegateProtocol {
    func sendDataToFirstViewController(myData: Bool)
    func sendDateDataToFirstViewController(myData: Date)
}


class NotesDetailTableViewCell: UITableViewCell{
    
    var delegate: MyDataSendingDelegateProtocol? = nil
    
    @IBOutlet weak var addReminderLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var switchReminderState: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var dateResultLabel: UILabel!
//    @IBOutlet weak var dateResultField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    var switches:Bool = false
    var dateResult = Date()
    func passData(sendSwitches: Bool){
        if self.delegate != nil{
            let dataToBeSent = self.switches
            self.delegate?.sendDataToFirstViewController(myData: dataToBeSent)
        }
    }
    
    func passDateDate(sendDate: Date){
        if self.delegate != nil{
            let dataToBeSent = self.dateResult
            self.delegate?.sendDateDataToFirstViewController(myData: dataToBeSent)
        }
    }
    
    
    @IBAction func switchReminder(_ sender: UISwitch) {
        
        if switchReminderState.isOn {
            switches = true
            passData(sendSwitches: switches)
        }
        else{
            switches = false
            passData(sendSwitches: switches)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension NotesDetailTableViewCell{
    @IBAction func getDate(_ sender: UIDatePicker){
        
        dateResult = sender.date
        passDateDate(sendDate: dateResult)
    }
}
