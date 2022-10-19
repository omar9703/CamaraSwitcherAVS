//
//  BotonesOcultosCollectionViewCell.swift
//  CamaraSwitcherAVS
//
//  Created by Omar Campos on 17/10/22.
//

import UIKit

class BotonesOcultosCollectionViewCell: UICollectionViewCell {
    var canal : camaraChannel?
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var canalLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        switcher.isOn = true
        // Initialization code
    }

    @IBAction func updateSwitch(_ sender: UISwitch) {
        if sender.isOn
        {
            self.canal?.hidden = true
            CamaraEntity.UpdateChannel(channel: self.canal!)
        }
        else
        {
            self.canal?.hidden = false
            CamaraEntity.UpdateChannel(channel: self.canal!)
        }
    }
}
