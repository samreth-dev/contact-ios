//
//  ContactTableViewCellViewModel.swift
//  ContactApp
//
//  Created by Samreth Kem on 12/6/22.
//

import Foundation

protocol ContactTableViewCellViewModelProtocol {
    var contact: Contact { get set }
    var isDeleteMode: Bool { get set }
    
    func clickDelete()
}

class ContactTableViewCellViewModel {
    private var clickCallBack: (Contact) -> Void
    private var index: Int
    var contact: Contact
    var isDeleteMode: Bool
    
    init(clickCallBack: @escaping (Contact) -> Void, index: Int, contact: Contact, isDeleteMode: Bool) {
        self.clickCallBack = clickCallBack
        self.index = index
        self.contact = contact
        self.isDeleteMode = isDeleteMode
    }
}

extension ContactTableViewCellViewModel: ContactTableViewCellViewModelProtocol {
    func clickDelete() {
        isDeleteMode.toggle()
        clickCallBack(contact)
    }
}
