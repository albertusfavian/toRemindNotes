//
//  ToDoVC.swift
//  toRemindNotes
//
//  Created by Mac-albert on 29/04/21.
//

import UIKit
import CoreData

var ReminderList = [Notes]()

class ToDoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, sendDatatoCoreData, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var firstLoad = true
    var tagNotesChanged = ""
    var filteredData: [Notes] = ReminderList
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
    
    @IBOutlet weak var tableViewReminder: UITableView!
    
    let search = UISearchController()
    
    func sendImageDidTap(myData: String) {
        tagNotesChanged = myData
        tableViewReminder.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{
            return
        }
        filteredData = []
        if text == "" {
            filteredData = ReminderList
        }
        else{
            for note in ReminderList {
                if note.title.lowercased().contains(text.lowercased()){
                    filteredData.append(note)
                }
            }
        }
        self.tableViewReminder.reloadData()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Populate Row Reminder: \(ReminderList.count)")
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reminderCell = tableView.dequeueReusableCell(withIdentifier: "ToDoTableViewCell") as! ToDoDetailTableViewCell
        let thisNote: Notes!
        thisNote = filteredData[indexPath.row]
        if thisNote.tagNotes == "Check"{
            reminderCell.backgroundColor = .systemGray6
            reminderCell.titleLabel.text = thisNote.title
            let format = DateFormatter()
            format.dateFormat = "dd MMM yyyy"
            let dateShow = format.string(from: thisNote.date)
            reminderCell.dateLabel.text = dateShow
    //        thisNote.tagNotes = tagNotesChanged
    //        print("remineder tag: \(thisNote.tagNotes)")
            reminderCell.buttonImage.setImage(UIImage(named: thisNote.tagNotes), for: UIControl.State.normal)
        }
        else {
            reminderCell.titleLabel.text = thisNote.title
            let format = DateFormatter()
            format.dateFormat = "dd MMM yyyy"
            let dateShow = format.string(from: thisNote.date)
            reminderCell.dateLabel.text = dateShow
    //        thisNote.tagNotes = tagNotesChanged
    //        print("remineder tag: \(thisNote.tagNotes)")
            reminderCell.buttonImage.setImage(UIImage(named: thisNote.tagNotes), for: UIControl.State.normal)
        }
        
        return reminderCell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete"){
            (action, view, completionHandler) in
            
            let decisionToRemove = self.filteredData[indexPath.row]
            
            self.context.delete(decisionToRemove)
            
            try! self.context.save()
            
            self.reloadTable()
            
            self.viewDidAppear(true)
            
        }
        return UISwipeActionsConfiguration(actions: [actionDelete])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDone = UIContextualAction(style: .normal, title: "Done"){
            (action, view, completionHandler) in
            
            let decisionToDone = self.filteredData[indexPath.row]
            
            decisionToDone.tagNotes = "Check"
            
            try! self.context.save()
            
            self.reloadTable()
            
            self.viewDidAppear(true)
        }
        actionDone.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [actionDone])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.searchResultsUpdater = self
        search.delegate = self
        navigationItem.searchController = search
        tableViewReminder.delegate = self
        tableViewReminder.dataSource = self
        if (firstLoad) {
            firstLoad = false
            reloadTable()
        }
        filteredData = ReminderList
        
        // Do any additional setup after loading the view.
    }
    func reloadTable(){
        
        do{
            let results:NSArray = try context.fetch(request) as NSArray
            print(results.count)
            for result in results {
                let note = result as! Notes
                if note.reminder == true {
                    ReminderList.append(note)
                }
                else{
                    
                }
            }
            filteredData = ReminderList
        }
        catch{
            print("Fetch Failed")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        ReminderList.removeAll()
        DispatchQueue.main.async {
            self.reloadTable()
            self.tableViewReminder.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editReminder", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editReminder"){
            let indexPath = tableViewReminder.indexPathForSelectedRow!
            
            let noteDetail = segue.destination as? NotesDetailVC
            
            let selectedNote: Notes!
            selectedNote = ReminderList[indexPath.row]
            noteDetail?.selectedNote = selectedNote
            tableViewReminder.deselectRow(at: indexPath, animated: true)
            
            
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange text: String){
        filteredData = []
        if text == "" {
            filteredData = noteList
        }
        else{
            for note in noteList {
                if note.title.lowercased().contains(text.lowercased()){
                    filteredData.append(note)
                }
            }
        }
        self.tableViewReminder.reloadData()
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
