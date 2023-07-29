//
//  MSP_ClaimPointsTVC.swift
//  MSP_Customer
//
//  Created by ADMIN on 24/11/2022.
//

import UIKit
protocol SendDetailsDelegate: NSObject{
    func qtyValue(_ cell: MSP_ClaimPointsTVC)
    func remarksValue(_ cell: MSP_ClaimPointsTVC)
}
class MSP_ClaimPointsTVC: UITableViewCell, UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var remarksTF: UITextField!
    @IBOutlet weak var productNameTitle: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var qtyTF: UITextField!
    @IBOutlet weak var qtyLbl: UILabel!
    
    weak var delegate: SendDetailsDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.qtyTF.delegate = self
       // self.remarksTF.delegate = self
        self.qtyTF.setLeftPaddingPoints(12)
        self.remarksTF.setLeftPaddingPoints(12)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func enteredQTYEditingDidEnd(_ sender: Any) {
//        if  self.qtyTF.text?.count != 0{
            self.delegate.qtyValue(self)
//        }
    }
    
    @IBAction func enterRemarksEditingDidEnd(_ sender: Any) {
        self.delegate.remarksValue(self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let replacedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let decimalPattern = "^\\d*\\.?\\d{0,3}$"
        let decimalRegex = try! NSRegularExpression(pattern: decimalPattern, options: [])
        let matches = decimalRegex.matches(in: replacedText, options: [], range: NSRange(location: 0, length: replacedText.utf16.count))
        if matches.count > 0 {
            if replacedText == "." {
                textField.text = "0" + replacedText
                return false
            }
            return true
        } else {
            return false
        }
        
    }
}
