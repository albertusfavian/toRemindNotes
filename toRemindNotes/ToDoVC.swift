//
//  ToDoVC.swift
//  toRemindNotes
//
//  Created by Mac-albert on 29/04/21.
//

import UIKit
import CoreData


class ToDoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var firstLoad = true
    
    @IBOutlet weak var tableViewReminder: UITableView!
    
    let search = UISearchController()
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{
            return
        }
        print(text)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reminderCell = tableView.dequeueReusableCell(withIdentifier: "ToDoTableViewCell") as! ToDoDetailTableViewCell
        let thisNote: Notes!
        thisNote = noteList[indexPath.row]
        
        reminderCell.titleLabel.text = thisNote.title
//        reminderCell.dateLabel.text = thisNote.date
//        reminderCell.checkmark.image = UIImage(named: <#T##String#>)
        return reminderCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = search
        tableViewReminder.delegate = self
        tableViewReminder.dataSource = self
        if (firstLoad) {
            firstLoad = false
            reloadTable()
        }
        
        // Do any additional setup after loading the view.
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
                if note.reminder == true {
                    noteList.append(note)
                }
                else{
                    print("ini Notes")
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
            selectedNote = noteList[indexPath.row]
            noteDetail?.selectedNote = selectedNote
            tableViewReminder.deselectRow(at: indexPath, animated: true)
            
            
        }
    }
    @IBAction func searchBar(){
        
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
