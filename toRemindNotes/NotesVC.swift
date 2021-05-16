//
//  NotesVC.swift
//  toRemindNotes
//
//  Created by Mac-albert on 29/04/21.
//

import UIKit
import CoreData 


var noteList = [Notes]()


class NotesVC: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {

    var firstLoad = true
    
    var filteredData: [Notes] = noteList
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
    
//    var filteredNoteList: Notes = []()
    
    @IBOutlet weak var tableViewNotes: UITableView!
    
    let search = UISearchController(searchResultsController: nil)
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{
            return
        }
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
        self.tableViewNotes.reloadData()
        
    }
}

extension NotesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let notesCell = tableView.dequeueReusableCell(withIdentifier: "NotesTableViewCell") as! NotesTVC
        
        let thisNote: Notes!
        thisNote = filteredData[indexPath.row]
        
        notesCell.titleNameLabel.text = thisNote.title
        notesCell.contentLabel.text = thisNote.content
        notesCell.tagLabel?.image = UIImage(named: thisNote.tagNotes)
        
        return notesCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Populate Row = \(noteList.count)")
        
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editNote", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
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
    func reloadTable(){
        do{
            let results:NSArray = try context.fetch(request) as NSArray
            print(results.count)
            for result in results {
                let note = result as! Notes
                if note.reminder == false {
                    noteList.append(note)
                }
                else{
                    
                }
            }
            filteredData = noteList
        }
        catch{
            print("Fetch Failed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.searchResultsUpdater = self
        search.delegate = self
        navigationItem.searchController = search
        // Do any additional setup after loading the view.
        tableViewNotes.delegate = self
        tableViewNotes.dataSource = self
        if (firstLoad){
            firstLoad = false
            reloadTable()
        }
        filteredData = noteList
    }
    
    override func viewDidAppear(_ animated: Bool) {
        noteList.removeAll()
        filteredData.removeAll()
        DispatchQueue.main.async {
            self.reloadTable()
            print ("reload data")
            self.tableViewNotes.reloadData()
            
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editNote"){
            let indexPath = tableViewNotes.indexPathForSelectedRow!
            
            let noteDetail = segue.destination as? NotesDetailVC
            
            let selectedNote: Notes!
            selectedNote = noteList[indexPath.row]
            noteDetail?.selectedNote = selectedNote
            tableViewNotes.deselectRow(at: indexPath, animated: true)
        }
        
//        SEARCH
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
            self.tableViewNotes.reloadData()
        }
    }
}
