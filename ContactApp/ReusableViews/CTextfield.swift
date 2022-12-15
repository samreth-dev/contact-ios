//
//  CTextfield.swift
//  ContactApp
//
//  Created by Samreth Kem on 12/5/22.
//

import UIKit

class CTextfield: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var textField: UITextField!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initXibView()
        setup()
    }
    
    private func initXibView() {
        let xibView = Bundle.main.loadNibNamed("CTextfield", owner: self, options: nil)![0] as! UIView
        xibView.frame = bounds
        addSubview(xibView)
    }
    
    private func setup() {
        view.layer.cornerRadius = 5
    }
}
