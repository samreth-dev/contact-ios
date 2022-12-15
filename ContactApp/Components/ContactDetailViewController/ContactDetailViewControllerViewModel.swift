//
//  ContactDetailViewControllerViewModel.swift
//  ContactApp
//
//  Created by Samreth Kem on 12/6/22.
//

import Foundation

protocol ContactDetailViewControllerViewModelProtocol {
    var contact: Contact { get set }
    var editCallBack: (Contact) -> () { get set }
    
    func getTitle(index: Int) -> String
    func getInfo(index: Int) -> String
    func getContactGroup() -> ContactGroup
    func getProfile() -> Data?
    func save(fullname: String, mobile: Int, group: String, nickname: String, profile: Data?)
    func saveProfile(profile: Data?)
}

class ContactDetailViewControllerViewModel: ContactDetailViewControllerViewModelProtocol {
    var contact: Contact
    var editCallBack: (Contact) -> ()
    
    init(contact: Contact, editCallBack: @escaping (Contact) -> Void) {
        self.contact = contact
        self.editCallBack = editCallBack
    }
    
    func getTitle(index: Int) -> String {
        switch index {
        case 0:
            return "Fullname"
        case 1:
            return "Mobile"
        case 2:
            return "Group"
        case 3:
            return "Nickname"
        default:
            return ""
        }
    }
    
    func getInfo(index: Int) -> String {
        switch index {
        case 0:
            return contact.fullname ?? ""
        case 1:
            return contact.mobile.description
        case 2:
            return contact.group ?? ""
        case 3:
            return contact.nickname ?? ""
        default:
            return ""
        }
    }
    
    func getContactGroup() -> ContactGroup {
        guard let rawString = contact.group else { return .defaultGroup}
        return ContactGroup(rawValue: rawString) ?? .defaultGroup
    }
 
    func getProfile() -> Data? {
        contact.profile
    }
    
    func save(fullname: String, mobile: Int, group: String, nickname: String, profile: Data?) {
        contact.profile = profile
        DB.shared.saveContacts()
    }
    
    func saveProfile(profile: Data?) {
        contact.profile = profile
        DB.shared.saveContacts()
    }
}
