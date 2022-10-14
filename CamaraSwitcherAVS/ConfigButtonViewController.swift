//
//  ConfigButtonViewController.swift
//  CamaraSwitcherAVS
//
//  Created by Omar Campos on 11/10/22.
//

import UIKit

protocol configPropertiesButtonDelegate {
    func configsSelected(ultrix : Int, panasonic : Int, nombre : String)
}

class ConfigButtonViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var titulo = ""
    var rowUltrix  = 0
    var rowPansonic = 0
    var panaChannels = [String]()
    var ultChannels = [String]()
    var delegate : configPropertiesButtonDelegate?
    @IBOutlet weak var tituloField: UITextField!
    @IBOutlet weak var panaPicker: UIPickerView!
    @IBOutlet weak var ultrixpicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        for x in Range(1...100)
        {
            ultChannels.append("SRC \(x)")
        }
        for x in Range(1...200)
        {
            panaChannels.append("Camara \(x)")
        }
        
        tituloField.text = titulo
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ultrixpicker.selectRow(rowUltrix, inComponent: 0, animated: true)
        panaPicker.selectRow(rowPansonic, inComponent: 0, animated: true)
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        delegate?.configsSelected(ultrix: rowUltrix, panasonic: rowPansonic, nombre: tituloField.text ?? "")
        self.dismiss(animated: true, completion: nil)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0
        {
            return ultChannels.count
        }
        else
        {
            return panaChannels.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0
        {
            return ultChannels[row]
        }
        else
        {
            return panaChannels[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0
        {
            rowUltrix = row
        }
        else
        {
            rowPansonic = row
        }
    }

}
