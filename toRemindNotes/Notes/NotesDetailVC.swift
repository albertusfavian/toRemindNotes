//
//  NotesDetailVC.swift
//  toRemindNotes
//
//  Created by Mac-albert on 02/05/21.
//

import UIKit
import CoreData


class NotesDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MyDataSendingDelegateProtocol {
    
    var tempIndex = 0
    var selectedNote: Notes? = nil
    var switches: Bool?
    var dateResult: Date = Date()
//    var dateResultSave: Date = Date()
    
    @IBOutlet weak var tableViewDetail: UITableView!
    @IBOutlet weak var titleName: UITextField!
    @IBOutlet weak var contentNotes: UITextView!
    
    func sendDataToFirstViewController(myData: Bool) {
        switches = myData
        tableViewDetail.reloadData()
    }
    
    func sendDateDataToFirstViewController(myData: Date) {
        dateResult = myData
        print("setelah dilempar: \(dateResult)")
//        tableViewDetail.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("Cek berapa cell: \(selectedNote?.reminder)")
        if switches == true{
            return 3
        }
        else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let notesDetailCell = tableView.dequeueReusableCell(withIdentifier: "reminderSwitch", for: indexPath) as? NotesDetailTableViewCell
                notesDetailCell?.addReminderLabel.text = "Add Reminder"
            notesDetailCell?.delegate = self
            notesDetailCell?.switchReminderState.setOn(switches ?? false, animated: true)
//            print(switches)
//            print("buat state: \(selectedNote?.reminder)")
//            if selectedNote?.reminder == true{
//
//            }
//            else{
//
//            }
//            return notesDetailCell!
            return notesDetailCell ?? UITableViewCell()
            
        }
        else if indexPath.row == 1{
            let notesDetailCell = tableView.dequeueReusableCell(withIdentifier: "tagImportant", for: indexPath) as? NotesDetailTableViewCell
                notesDetailCell?.tagLabel.text = "Tag"
            return notesDetailCell!
        }
        else{
            let notesDetailCell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as? NotesDetailTableViewCell
            notesDetailCell?.delegate = self
            notesDetailCell?.dateLabel.text = "Date Label"
//            print("buat cell: \(selectedNote?.reminder)")
            if switches == false{
                notesDetailCell?.isHidden = true
            }
            else if switches == true{
                notesDetailCell?.isHidden = false
            }
            print(dateResult)
            notesDetailCell?.datePicker.setDate(dateResult, animated: true)
            
            let picker = UIDatePicker()
            picker.datePickerMode = .date
            picker.preferredDatePickerStyle = .compact
            notesDetailCell?.datePicker = picker
            picker.addTarget(self, action: #selector(pickerSelected(sender:)), for: .valueChanged)
            
            return notesDetailCell ?? UITableViewCell()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        if(selectedNote != nil){
            titleName.text = selectedNote?.title
            contentNotes.text = selectedNote?.content
        }
        if selectedNote?.reminder == true{
            self.navigationItem.title = "To-Do Detail"
        }else{
            self.navigationItem.title = "Notes Detail"
        }
        
        tableViewDetail.reloadData()
        tableViewDetail.delegate = self
        tableViewDetail.dataSource = self
        contentNotes.layer.borderWidth = 1
        contentNotes.layer.cornerRadius = 20
        contentNotes.layer.borderColor = UIColor.systemGray.cgColor
        textViewDidChange(contentNotes)
        contentNotes.font = UIFont(name: contentNotes.font!.fontName, size: 15)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        switches = selectedNote?.reminder
        dateResult = selectedNote?.date ?? Date()

        
        
        
        
    }

    
    
    @objc func pickerSelected(sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
//        dateResult = formatter.(from: sender.date)
        dateResult = sender.date
        
        
        
    }
    //Calls this function when the tap is recognized.
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
//    func nonDeletedNotes() -> [Notes] {
//        var nonDeletedNoteList = [Notes]()
//
//
//        return nonDeletedNotes()
//    }
//
    
    @IBAction func saveAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if(selectedNote == nil){
            let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
            let newNote = Notes(entity: entity!, insertInto: context)
            newNote.id = noteList.count as NSNumber
            newNote.title = titleName.text
            newNote.content = contentNotes.text
            do{
                try context.save()
                noteList.append(newNote)
                navigationController?.popViewController(animated: true)
            }
            catch{
                print("context save error ")
            }
        }
        else{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
            do{
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let note = result as! Notes
                    if (note==selectedNote) {
                        note.title = titleName.text
                        note.content = contentNotes.text
                        note.reminder = switches ?? true
                        note.date = dateResult
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
            catch{
                print("Fetch Failed")
            }
        }
        
        
        
    }
    
    @IBAction func DeleteNote(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
//        self.tableviewnoted
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        do{
            let results:NSArray = try context.fetch(request) as NSArray
            print(results.count)
            for result in results {
                let note = result as! Notes
                if (note == selectedNote) {
//                    print(note.title)
                    context.delete(note)
                    try context.save()
                    navigationController?.popViewController(animated: true)
                    
                }
            }
        }
        catch{
            print("Fetch Failed")
        }
    }
}
