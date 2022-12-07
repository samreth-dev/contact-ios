//
//  ContactDetailTableViewCell.swift
//  ContactApp
//
//  Created by Samreth Kem on 12/6/22.
//

import UIKit

class ContactDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    private var viewModel: ContactDetailViewModelProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(viewModel: ContactDetailViewModelProtocol) {
        self.titleLabel.text = viewModel.title
        self.infoLabel.text = viewModel.info
        self.viewModel = viewModel
    }
}
