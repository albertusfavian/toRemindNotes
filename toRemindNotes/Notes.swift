import CoreData

@objc(Notes)

class Notes: NSManagedObject {
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var tagNotes: String!
    @NSManaged var content: String!
    @NSManaged var date: Date!
    @NSManaged var reminder: Bool
}
