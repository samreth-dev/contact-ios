//
//  DB.swift
//  Phone-Call
//
//  Created by Samreth Kem on 12/4/22.
//

import Foundation
import CoreData

class DB {
    static let shared = DB()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ContactApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        get {
            persistentContainer.viewContext
        }
    }
    
    func fetch() -> [Contact] {
        do {
            return try context.fetch(Contact.fetchRequest())
        }
        catch {
            return []
        }
    }
    
    func addContact(fullname: String, mobile: Int, group: ContactGroup, nickname: String) -> Contact {
        let contact = Contact(context: context)
        contact.fullname = fullname
        contact.mobile = Int64(mobile)
        contact.group = group.rawValue
        contact.nickname = nickname
        try? context.save()
        return contact
    }
    
    func editContact (contact: Contact, fullname: String, mobile: Int, group: ContactGroup, nickname: String) -> Contact {
        contact.fullname = fullname
        contact.mobile = Int64(mobile)
        contact.group = group.rawValue
        contact.nickname = nickname
        try? context.save()
        return contact
    }

    func deleteContact(_ contact: Contact) {
        context.delete(contact)
        saveContacts()
    }
    
    func saveContacts() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private init() {}
}
