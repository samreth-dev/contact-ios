//
//  HeaderView.swift
//  ContactApp
//
//  Created by Samreth Kem on 12/6/22.
//

import UIKit

class HeaderView: UIView {
    var imageView: UIImageView!
    var viewModel: HeaderViewModelProtocol!
    
    init(viewModel: HeaderViewModelProtocol) {
        super.init(frame: CGRect())
        self.viewModel = viewModel
        setup()
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setup() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 100
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .black
        
        addSubview(imageView)
    }
}
