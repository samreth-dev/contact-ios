//
//  ViewController.swift
//  Phone-Call
//
//  Created by Samreth Kem on 12/4/22.
//

import UIKit
import Combine

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var tableView: UITableView!
    private var addButton: UIButton!
    private var stackView: UIStackView!
    private var viewModel = ViewControllerViewModel()
    private var editButton: UIBarButtonItem!
    private var cancellable: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        binding()
        viewModel.setCallBack()
        viewModel.fetch()
    }
    
    private func setup() {
        editButton = editButtonItem
        editButton.tintColor = .systemBlue
        editButton.action = #selector(edit)
        editButton.target = self
        navigationItem.rightBarButtonItem = editButton
        
        addButton = UIButton(type: .system, primaryAction: .none)
        addButton.setTitle("ADD", for: .normal)
        addButton.addTarget(self, action: #selector(addContact), for: .touchUpInside)
        
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(addButton)
        stackView.frame = CGRect(x: 0, y: 0, width: toolbar.frame.width, height: toolbar.frame.height)
        stackView.distribution = .fillEqually
        toolbar.addSubview(stackView)
        
        let nib = UINib(nibName: "ContactTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ContactTableViewCell")
    }
    
    private func binding() {
        viewModel.$reloadToggle.sink {[weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellable)
    }
}

//MARK: UI change functions
private extension ViewController {
    func showDeleteAlert(index: Int) {
        let alertController = UIAlertController(title: "Deleting a Contact", message: "Are you sure you want to delete this contact?", preferredStyle: .alert)
        let confirmAlertAction = UIAlertAction(title: "CONFIRM", style: .destructive) {[weak self] _ in
            self?.viewModel.delete(index: index)
        }
        let cancelAlertAction = UIAlertAction(title: "CANCEL", style: .cancel)
        
        alertController.addAction(confirmAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true)
    }
    
    func showDeletesAlert() {
        let alertController = UIAlertController(title: "Deleting Contacts", message: "Are you sure you want to delete the selected contacts?", preferredStyle: .alert)
        let confirmAlertAction = UIAlertAction(title: "CONFIRM", style: .destructive) {[weak self] _ in
            self?.viewModel.deleteAll()
            self?.buttonToggleToEdit()
        }
        let cancelAlertAction = UIAlertAction(title: "CANCEL", style: .cancel) {[weak self] _ in
            self?.buttonToggleToEdit()
        }
        
        alertController.addAction(confirmAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true)
    }
    
    func buttonToggleToEdit() {
        editButton.title = "Edit"
        editButton.tintColor = .systemBlue
        editButton.style = .plain
        viewModel.release()
        viewModel.isEdit.toggle()
        tableView.reloadData()
    }
    
    func buttonToggleToDelete() {
        editButton.title = "Delete"
        editButton.tintColor = .systemRed
        editButton.style = .done
        viewModel.isEdit.toggle()
        tableView.reloadData()
    }
}

//MARK: actions
private extension ViewController {
    @objc private func addContact() {
        let addViewModel = AddViewModel(contactGroup: .defaultGroup, contact: nil, title: "ADD") {[weak self] contact in
            self?.viewModel.reload(contact: contact)
        }
        
        present(AddViewController(addViewModel: addViewModel), animated: true)
    }
    
    @objc private func edit() {
        if viewModel.isEdit {
            if !viewModel.isContactsEmpty {
                showDeletesAlert()
            } else {
                buttonToggleToEdit()
            }
        } else {
            buttonToggleToDelete()
        }
    }
}

//MARK: datasource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as? ContactTableViewCell else { return UITableViewCell() }
        
        let cellViewModel = ContactTableViewCellViewModel(clickCallBack: viewModel.clickCallBack, index: indexPath.row, contact: viewModel.contacts[indexPath.row], isDeleteMode: false)
        
        cell.config(viewModel: cellViewModel)
        
        if viewModel.isEdit {
            cell.deleteButton.alpha = 1
            return cell
        } else {
            cell.deleteButton.alpha = 0
            cell.deleteButton.tintColor = .systemGray5
            return cell
        }
    }
}

//MARK: delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showDeleteAlert(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactDetailViewModel = ContactDetailViewControllerViewModel(contact: viewModel.contacts[indexPath.row]) {[weak self] contact in
            self?.viewModel.reload(contact: contact)
        }
        
        navigationController?.pushViewController(ContactDetailViewController(viewModel: contactDetailViewModel), animated: true)
    }
}

