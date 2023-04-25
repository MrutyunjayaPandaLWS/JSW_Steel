//
//  Catalogue_CVC.swift
//  centuryDemo
//
//  Created by Arkmacbook on 10/03/22.
//

import UIKit

class Catalogue_CVC: UICollectionViewCell {
    
    @IBOutlet var catalogurLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected{
                catalogurLabel.textColor = isSelected ? .white : .white
                catalogurLabel.backgroundColor = isSelected ? #colorLiteral(red: 0.9555373788, green: 0.4757598639, blue: 0.1325500607, alpha: 1) : #colorLiteral(red: 0.4344037771, green: 0.4393812716, blue: 0.5076696277, alpha: 1)
            }else{
                catalogurLabel.backgroundColor = #colorLiteral(red: 0.4344037771, green: 0.4393812716, blue: 0.5076696277, alpha: 1)
            }
        }
    }
}
