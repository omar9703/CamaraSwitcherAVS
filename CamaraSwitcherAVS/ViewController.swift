//
//  ViewController.swift
//  CamaraSwitcherAVS
//
//  Created by Omar Campos on 23/09/22.
//

import UIKit

class ViewController: UIViewController,PickerImageDelegate, buttonActionsConfigDelegate, configPropertiesButtonDelegate {
    var botonSelected : CanalButton?
    @IBOutlet weak var fondo: UIImageView!
    @IBOutlet weak var configButton: UIButton!
    @IBOutlet var buttonsCamera : [UIButton]!
    @IBOutlet weak var configLabel: UILabel!
    @IBOutlet weak var ultrixStats: UIView!
    @IBOutlet weak var panasonicStats: UIView!
    @IBOutlet weak var LabelTV: UILabel!
    @IBOutlet weak var switchConfig: UISwitch!
    @IBOutlet weak var const2: NSLayoutConstraint!
    @IBOutlet weak var const1: NSLayoutConstraint!
    var buttonCenter : CGPoint = .zero
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(self.panGestureSettings(_:))))
        LabelTV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tvActionSelected(_:))))
        var co = 0
        var alt = 0
        panasonicStats.layer.cornerRadius = 12
        ultrixStats.layer.cornerRadius = 12
        for x in Range(0...49)
        {
            if x == 10 || x == 19 || x == 28 || x == 37 || x == 46
            {
                co = 0
                alt = alt + 70
            }
        let bu = CanalButton(frame: CGRect(x: 235 + (co*70), y: 210 + alt, width: 50, height: 50))
        bu.setTitle("\(x + 1)", for: .normal)
        bu.backgroundColor = .lightGray
            bu.delegate = self
        bu.setup()
        self.view.addSubview(bu)
            co = co + 1
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LabelTV.text = "Destination Ultrix \(UserDefaults.standard.integer(forKey: "destiny") + 1)"
        pingFunction()
//        self.view.removeConstraints([const1,const2])
//        self.view.removeConstraints(self.view.constraints)
        loadImage()
    }
    @objc func tvActionSelected(_ sender : UITapGestureRecognizer)
    {
        if UserDefaults.standard.bool(forKey: "config")
        {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickerController") as! PickerDestinyViewController
            vc.delegate = self
            vc.row = UserDefaults.standard.integer(forKey: "destiny")
            vc.isDestiny = .destiny
            self.present(vc, animated: true, completion: nil)
        }
    }
    func loadImage() {
         guard let data = UserDefaults.standard.data(forKey: "KEY") else { return }
         let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
         let image = UIImage(data: decoded)
        fondo.image = image
    }

    @IBAction func changeSwitch(_ sender: UISwitch) {
        if sender.isOn
        {
            configButton.isHidden = false
            UserDefaults.standard.set(true, forKey: "config")
        }
        else
        {
            UserDefaults.standard.set(false, forKey: "config")
            configButton.isHidden = true
            configLabel.isHidden = true
            switchConfig.isHidden = true
            sender.isHidden = true
        }
    }
    func pingFunction()
    {
        let pingInterval:TimeInterval = 2
        let timeoutInterval:TimeInterval = 1
        let configuration = PingConfiguration(interval: pingInterval, with: timeoutInterval)
        if let ipUltrix = UserDefaults.standard.string(forKey: "ultrix") {
        let pinger = try? SwiftyPing(host: ipUltrix, configuration: PingConfiguration(interval: 0.5, with: 5), queue: DispatchQueue.global())
        pinger?.observer = { (response) in
            let duration = response.duration
//            print(duration,response)
            if let e = response.error
            {
                DispatchQueue.main.async {
                    UserDefaults.standard.set(false, forKey: "ultStats")
                    self.ultrixStats.backgroundColor = .red
                }
            }
            else
            {
                DispatchQueue.main.async {
                    UserDefaults.standard.set(true, forKey: "ultStats")
                    self.panasonicStats.backgroundColor = .green
                }
            }
        }
        try? pinger?.startPinging()
        }
        if let ipYamaha = UserDefaults.standard.string(forKey: "panasonic") {
            let pinger = try? SwiftyPing(host: ipYamaha, configuration: PingConfiguration(interval: 0.5, with: 5), queue: DispatchQueue.global())
            pinger?.observer = { (response) in
                let duration = response.duration
//                print(duration,response)
                if let e = response.error
                {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(false, forKey: "panaStats")
                        self.panasonicStats.backgroundColor = .red
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(true, forKey: "panaStats")
                        self.panasonicStats.backgroundColor = .green
                    }
                }
            }
            try? pinger?.startPinging()
        }
        
    }
    @objc func panButton(pan: UIPanGestureRecognizer) {
        var loc = pan.location(in: self.view)
        pan.view!.center = loc
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        print("longpressed",sender.view?.tag)
//           delegate?.selectedSourceButton(tag: sender.view?.tag ?? 0, boton: self)
       }
    @IBAction func configPicker(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "picker") as! GeneralConfigViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    @objc func panGestureSettings(_ sender : UIPinchGestureRecognizer)
    {
        debugPrint("gesture")
        configLabel.isHidden = false
        switchConfig.isHidden = false
//        .isHidden = false
//        mixLabel.text = "Mix \(sliderView.tag)"
    }
    
    func imagenSeleccionado(imagen: UIImage?) {
        if let imagen = imagen
        {
            self.fondo.image = imagen
        }
    }

    func openButtonConfig(boton: CanalButton) {
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "config") as! ConfigButtonViewController
        vc.rowPansonic = boton.idPanasonic - 1
        vc.rowUltrix = boton.idUltrix - 1
        vc.titulo = boton.titleLabel?.text ?? ""
        vc.delegate = self
        botonSelected = boton
        self.present(vc, animated: true, completion: nil)
    }
    
    func configsSelected(ultrix: Int, panasonic: Int, nombre: String) {
        botonSelected?.idUltrix = ultrix + 1
        botonSelected?.idPanasonic = panasonic + 1
        botonSelected?.setTitle(nombre, for: .normal)
//        botonSelected?.setup()
        if let c = CamaraEntity.getCanal(tag: botonSelected?.tag ?? 1)
        {
            let y = camaraChannel(id: botonSelected?.tag ?? 1, ultrixId: ultrix + 1, nombre: nombre, robotId: panasonic + 1, xPoint: Float(botonSelected?.center.x ?? 0), yPoint: Float(botonSelected?.center.y ?? 0))
            CamaraEntity.UpdateChannel(channel: y)
        }
        else
        {
            let y = camaraChannel(id: botonSelected?.tag ?? 1, ultrixId: ultrix + 1, nombre: nombre, robotId: panasonic + 1, xPoint: Float(botonSelected?.center.x ?? 0), yPoint: Float(botonSelected?.center.y ?? 0))
            CamaraEntity.saveChannel(camara: y)
        }
    }
}
extension ViewController: pickerTvDelegate
{
    func tvSelected(row: Int, isDestiny: pickerType, nombre: String) {
        if isDestiny == .destiny
        {
        LabelTV.text = "Destination Ultrix \(row + 1)"
//        self.tvRow = row
        UserDefaults.standard.set(row, forKey: "destiny")
        }
    }
    
    
}

