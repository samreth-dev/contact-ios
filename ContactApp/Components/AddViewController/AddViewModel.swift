//
//  AddViewModel.swift
//  ContactApp
//
//  Created by Samreth Kem on 12/4/22.
//

import Foundation

protocol AddViewModelProtocol {
    var contactGroup: ContactGroup { get set }
    var contact: Contact? { get set }
    var title: String { get set }
    
    func editContact(fullname: String?, mobile: String?, group: ContactGroup, nickname: String?) -> Bool
    func addContact(fullname: String?, mobile: String?, group: ContactGroup, nickname: String?) -> Bool
}

class AddViewModel: AddViewModelProtocol {
    var contactGroup: ContactGroup
    var contact: Contact?
    var title: String
    private let addCallBack: (Contact) -> ()
    
    init(contactGroup: ContactGroup, contact: Contact?, title: String, addCallBack: @escaping (Contact) -> Void) {
        self.contactGroup = contactGroup
        self.contact = contact
        self.title = title
        self.addCallBack = addCallBack
    }
    
    func editContact(fullname: String?, mobile: String?, group: ContactGroup, nickname: String?) -> Bool {
        guard let contact = contact, let fullname = fullname, let mobile = Int(mobile ?? ""), let nickname = nickname else { return false }
        
        if !fullname.isEmpty && String(mobile).count > 0 && !nickname.isEmpty {
            let result = DB.shared.editContact(contact: contact, fullname: fullname, mobile: mobile, group: group, nickname: nickname)
            addCallBack(result)
            
            return true
        }
        
        return false
    }
    
    func addContact(fullname: String?, mobile: String?, group: ContactGroup, nickname: String?) -> Bool {
        guard let fullname = fullname, let mobile = Int(mobile ?? ""), let nickname = nickname else { return false }
        
        if !fullname.isEmpty && String(mobile).count > 0 && !nickname.isEmpty {
            let result = DB.shared.addContact(fullname: fullname, mobile: mobile, group: group, nickname: nickname)
            addCallBack(result)
            
            return true
        }
        return false
    }
}
