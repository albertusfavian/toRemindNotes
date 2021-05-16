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
    func sendPickerToFirstViewController(myData: String)
}


class NotesDetailTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    
    var delegate: MyDataSendingDelegateProtocol? = nil
    
    var pickerViewData = ["Important",
                  "Not So Important",
                  "Not Imporant"
    ]
    @IBOutlet weak var addReminderLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var switchReminderState: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var dateResultLabel: UILabel!
//    @IBOutlet weak var dateResultField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerString: UIPickerView!
    var switches:Bool = false
    var dateResult = Date()
    var pickerResult: String = ""
    func passData(sendSwitches: Bool){
        print("switcher: \(switches)")
        self.delegate?.sendDataToFirstViewController(myData: switches)
    }
    
    
    
    func passDateDate(sendDate: Date){
        if self.delegate != nil{
            let dataToBeSent = self.dateResult
            self.delegate?.sendDateDataToFirstViewController(myData: dataToBeSent)
        }
    }
    
    func passPickerData(sendPicker: String){
        if self.delegate != nil{
            print("passpicker data: \(pickerResult)")
            self.delegate?.sendPickerToFirstViewController(myData: pickerResult)
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
        self.pickerString?.delegate = self
        self.pickerString?.dataSource = self
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerResult = pickerViewData[row] as String
        print("pickerview: \(pickerResult)")
        passPickerData(sendPicker: pickerResult)
    }
    
}
