//
//  ContactDetailViewModel.swift
//  ContactApp
//
//  Created by Samreth Kem on 12/6/22.
//

import Foundation

protocol ContactDetailViewModelProtocol {
    var title: String { get set }
    var info: String { get set }
}

class ContactDetailViewModel: ContactDetailViewModelProtocol {
    var title: String
    var info: String
    init(title: String, info: String) {
        self.title = title
        self.info = info
    }
}
