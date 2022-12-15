//
//  AddViewController.swift
//  ContactApp
//
//  Created by Samreth Kem on 12/4/22.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet weak var fullnameTf: CTextfield!
    @IBOutlet weak var mobileTf: CTextfield!
    @IBOutlet weak var nicknameTf: CTextfield!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    private var viewModel: AddViewModelProtocol!
    
    init(addViewModel: AddViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = addViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupTextfields()
    }
}

//MARK: view configurations
private extension AddViewController {
    func setupButtons() {
        let item = UIAction(title: "Default Group") {[weak self] _ in
            self?.viewModel.contactGroup = .defaultGroup
        }
        let item1 = UIAction(title: "Friend") {[weak self] _ in
            self?.viewModel.contactGroup = .friend
        }
        let item2 = UIAction(title: "Honey") {[weak self] _ in
            self?.viewModel.contactGroup = .honey
        }
        let item3 = UIAction(title: "Family") {[weak self] _ in
            self?.viewModel.contactGroup = .family
        }
        let item4 = UIAction(title: "Colleague") {[weak self] _ in
            self?.viewModel.contactGroup = .colleague
        }
        let contactGroupMenu = UIMenu(title: "Group", options: .displayInline, children: [item, item1, item2, item3, item4]
        )
        
        groupButton.menu = contactGroupMenu
        addButton.setTitle(viewModel.title, for: .normal)
        addButton.layer.cornerRadius = 5
    }
    
    func setupTextfields() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(unfocusKeyboard))
        gesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(gesture)
        
        fullnameTf.textField.placeholder = "Full name"
        fullnameTf.textField.text = viewModel.contact?.fullname
        
        mobileTf.textField.placeholder = "Mobile"
        mobileTf.textField.keyboardType = .numberPad
        mobileTf.textField.text = viewModel.contact?.mobile.description
        
        nicknameTf.textField.placeholder = "Nickname"
        nicknameTf.textField.text = viewModel.contact?.nickname
    }
}

//MARK: actions
private extension AddViewController {
    @IBAction func addClick(_ sender: Any) {
        if viewModel.title == "ADD" {
            let didAdd = viewModel.addContact(fullname: fullnameTf.textField.text, mobile: mobileTf.textField.text, group: viewModel.contactGroup, nickname: nicknameTf.textField.text)
            
            if !didAdd {
                invalidInput()
            } else {
                dismiss(animated: true)
            }
        } else {
            let didAdd = viewModel.editContact(fullname: fullnameTf.textField.text, mobile: mobileTf.textField.text, group: viewModel.contactGroup, nickname: nicknameTf.textField.text)
            
            if !didAdd {
                invalidInput()
            } else {
                dismiss(animated: true)
            }
        }
    }
    
    @objc func unfocusKeyboard() {
        view.endEditing(true)
    }
    
    func invalidInput() {
        let alertController = UIAlertController(title: "Invalid Inputs", message: "All fields must not be empty! / Mobile must be numeric!", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true)
    }
}
