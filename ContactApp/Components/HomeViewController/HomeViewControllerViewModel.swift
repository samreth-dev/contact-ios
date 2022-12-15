//
//  ViewControllerViewModel.swift
//  ContactApp
//
//  Created by Samreth Kem on 12/4/22.
//

import Foundation
import CoreData
import Combine

protocol HomeViewControllerViewModelProtocol {
    var reloadToggle: Bool { get set }
    var reloadPublisher: Published<Bool>.Publisher { get }
    var contacts: [Contact] { get set }
    var isEdit: Bool { get set }
    var clickCallBack: ((Contact) -> ())! { get set }
    var isContactsEmpty: Bool  { get }
    var cancellable: Set<AnyCancellable> { get set }
    
    func fetch()
    func deleteAll()
    func setCallBack()
    func release()
    func delete(index: Int)
    func reload(contact: Contact)
}

class HomeViewControllerViewModel {
    @Published var reloadToggle: Bool
    private var contactsForDeleting: Set<Contact>
    var reloadPublisher: Published<Bool>.Publisher { $reloadToggle }
    var contacts: [Contact]
    var isEdit: Bool
    var clickCallBack: ((Contact) -> ())!
    var cancellable: Set<AnyCancellable>
    var isContactsEmpty: Bool {
        get {
            contactsForDeleting.isEmpty
        }
    }
    
    init(reloadToggle: Bool, contactsForDeleting: Set<Contact>, contacts: [Contact], isEdit: Bool, cancellable: Set<AnyCancellable>) {
        self.reloadToggle = reloadToggle
        self.contactsForDeleting = contactsForDeleting
        self.contacts = contacts
        self.isEdit = isEdit
        self.cancellable = cancellable
    }
    
    private func sort() {
        contacts.sort(by: { $0.fullname?.lowercased() ?? "ZZZ" < $1.fullname?.lowercased() ?? "ZZZ" })
    }
}

extension HomeViewControllerViewModel: HomeViewControllerViewModelProtocol {
    func fetch() {
        contacts = DB.shared.fetch()
        sort()
    }
    
    func deleteAll() {
        contactsForDeleting.forEach { DB.shared.deleteContact($0) }
        contactsForDeleting.forEach { sub in
            self.contacts.removeAll(where: { $0.isEqual(sub) })
        }
        reloadToggle.toggle()
    }
    
    func setCallBack() {
        clickCallBack = {[weak self] contact in
            guard let self = self else { return }
            if self.contactsForDeleting.contains(contact) {
                self.contactsForDeleting.remove(contact)
            } else {
                self.contactsForDeleting.insert(contact)
            }
        }
    }
    
    func release() {
        contactsForDeleting.removeAll()
    }
    
    func delete(index: Int) {
        DB.shared.deleteContact(self.contacts[index])
        contacts.remove(at: index)
        reloadToggle.toggle()
    }

    func reload(contact: Contact) {
        if !contacts.contains(contact) {
            contacts.append(contact)
            sort()
        } else {
            fetch()
        }
        reloadToggle.toggle()
    }
}
