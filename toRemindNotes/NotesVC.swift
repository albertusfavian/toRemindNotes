//
//  NotesVC.swift
//  toRemindNotes
//
//  Created by Mac-albert on 29/04/21.
//

import UIKit
import CoreData 


var noteList = [Notes]()

class NotesVC: UIViewController, UISearchResultsUpdating {

    var firstLoad = true
    
    @IBOutlet weak var tableViewNotes: UITableView!
    
    let search = UISearchController()
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{
            return
        }
        print(text)
        
    }
}

extension NotesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let notesCell = tableView.dequeueReusableCell(withIdentifier: "NotesTableViewCell") as! NotesTVC
        
        let thisNote: Notes!
        thisNote = noteList[indexPath.row]
        
        notesCell.titleNameLabel.text = thisNote.title
        notesCell.contentLabel.text = thisNote.content
        notesCell.tagLabel.image = UIImage(named: "red.png")
        
        return notesCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Populate Row = \(noteList.count)")
        return noteList.count
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.searchResultsUpdater = self
        navigationItem.searchController = search
        // Do any additional setup after loading the view.
        tableViewNotes.delegate = self
        tableViewNotes.dataSource = self
        if (firstLoad){
            firstLoad = false
            reloadTable()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }

    func reloadTable(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        do{
            let results:NSArray = try context.fetch(request) as NSArray
            print(results.count)
            for result in results {
                let note = result as! Notes
                if note.reminder == false {
                    noteList.append(note)
                }
                else{
                    print("ini todo")
                }
            }
        }
        catch{
            print("Fetch Failed")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        noteList.removeAll()
        DispatchQueue.main.async {
            self.reloadTable()
            self.tableViewNotes.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editNote", sender: self)
        
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
    }
}







//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let notesCell = tableView.dequeueReusableCell(withIdentifier: "NotesTableViewCell") as! NotesTableViewCell
//
//        let thisNote: Notes!
//        thisNote = noteList[indexPath.row]
//        notesCell.notesTitleLabel.text = thisNote.title
//        notesCell.notesTitleLabel.text = thisNote.content
//        notesCell.importantTagNotes.image = UIImage
//
//
//        return notesCell
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        tableViewNotes.reloadData()
//    }
