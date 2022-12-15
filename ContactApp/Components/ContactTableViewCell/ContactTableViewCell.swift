//
//  ContactTableViewCell.swift
//  ContactApp
//
//  Created by Samreth Kem on 12/4/22.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    private var viewModel: ContactTableViewCellViewModelProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = {
            let uiView = UIView()
            uiView.backgroundColor = .clear
            return uiView
        }()
    }
    
    func config(viewModel: ContactTableViewCellViewModelProtocol) {
        fullnameLabel.text = viewModel.contact.fullname
        mobileLabel.text = String(viewModel.contact.mobile)
        self.viewModel = viewModel
    }
    
    @IBAction func deleteClickAnimation(_ sender: Any) {
        if !viewModel.isDeleteMode {
            UIView.animate(withDuration: 0.25) {
                self.deleteButton.tintColor = .red
            }
            self.viewModel.clickDelete()
        } else {
            UIView.animate(withDuration: 0.25) {
                self.deleteButton.tintColor = .systemGray5
            }
            self.viewModel.clickDelete()
        }
    }
}
