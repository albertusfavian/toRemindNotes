//
//  ToDoDetailVC.swift
//  toRemindNotes
//
//  Created by Mac-albert on 03/05/21.
//

import UIKit
import CoreData

class ToDoDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableViewToDo: UITableView!
    @IBOutlet weak var titleName: UITextField!
    @IBOutlet weak var contentNotes: UITextView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let toDoDetailCell = tableView.dequeueReusableCell(withIdentifier: "reminderSwitch", for: indexPath) as? ToDoTVC
            toDoDetailCell?.addReminderLabel.text = "Add Reminder"
            return toDoDetailCell!
        }
        else if indexPath.row == 1{
            let toDoDetailCell = tableView.dequeueReusableCell(withIdentifier: "tagImportant", for: indexPath) as? ToDoTVC
            toDoDetailCell?.tagLabel.text = "Tag"
            return toDoDetailCell!
        }
        else{
            let toDoDetailCell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as? ToDoTVC
            toDoDetailCell?.dateLabel.text = "Date"
            return toDoDetailCell!
        }
    }

//    var selectedToDo: ToDo? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewToDo.delegate = self
        self.tableViewToDo.dataSource = self
        contentNotes.layer.borderWidth = 1
        contentNotes.layer.cornerRadius = 20
        contentNotes.layer.borderColor = UIColor.systemGray.cgColor
//        textViewDidChange(contentNotes)
        contentNotes.font = UIFont(name: contentNotes.font!.fontName, size: 15)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func textViewDidChange(_ textView: UITextView) {
        let mutableAttrStr = NSMutableAttributedString(string: textView.text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 15
        mutableAttrStr.addAttributes([NSAttributedString.Key.paragraphStyle:style], range: NSMakeRange(0, mutableAttrStr.length))
        textView.attributedText = mutableAttrStr
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
