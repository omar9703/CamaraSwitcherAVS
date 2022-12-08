//
//  CanalButton.swift
//  CamaraSwitcherAVS
//
//  Created by Omar Campos on 10/10/22.
//

import UIKit
import SocketSwift

@objc protocol buttonActionsConfigDelegate {
    func openButtonConfig(boton : CanalButton)
}

class CanalButton: UIButton {
    @IBOutlet weak var delegate : buttonActionsConfigDelegate?
    var presionado = false
    var idUltrix = 1
    var socket : Socket?
    var idPanasonic = 1
    var xConstraint: NSLayoutConstraint!
    var yConstraint: NSLayoutConstraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        setup()
    }
    public func setup() {
        self.tag = (Int(self.currentTitle ?? "0") ?? 0)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panButton(pan:)))
        self.addGestureRecognizer(pan)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.addGestureRecognizer(longPressRecognizer)
        self.addTarget(self, action: #selector(self.controlPressed(_:)), for: .touchUpInside)
        self.titleLabel?.font = .systemFont(ofSize: 10)
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor(red: 108/255, green: 127/255, blue: 227/255, alpha: 1).cgColor
        self.backgroundColor = UIColor(red: 61/255, green: 121/255, blue: 196/255, alpha: 1)
//        self.removeConstraints(self.constraints)
//        self.translatesAutoresizingMaskIntoConstraints = false
    
       
        if let c = CamaraEntity.getCanal(tag: self.tag)
        {
            self.setTitle(c.nombre, for: .normal)
            self.idUltrix = c.ultrixId ?? self.tag
            self.idPanasonic = c.robotId ?? self.tag
            self.isHidden = c.hidden
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
            {
                self.center = CGPoint(x: CGFloat( c.xPoint ?? 0), y: CGFloat( c.yPoint ?? 0))
//                self.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
//
            }
            
        }
        else
        {
            idUltrix = self.tag
            idPanasonic = self.tag
        }
//        let r = self.constraints.filter({$0 != widthAnchor})
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.xConstraint = self.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor, constant: 100)
//                           self.yConstraint = self.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor, constant: 50)
//                           NSLayoutConstraint.activate([
//                               self.xConstraint, self.yConstraint,
//                           ])
//        }
//        self.frame.size = CGSize(width: 50, height: 50)
       
    }
    @objc func panButton(pan: UIPanGestureRecognizer) {
        if UserDefaults.standard.bool(forKey: "config")
        {
            let loc = pan.location(in: pan.view!.superview!)
            pan.view!.center = loc
            if let c = CamaraEntity.getCanal(tag: self.tag)
            {
                let y = camaraChannel(id: self.tag, ultrixId: idUltrix, nombre: self.titleLabel?.text ?? "", robotId: idPanasonic, xPoint: Float(loc.x), yPoint: Float(loc.y),hidden: false)
                CamaraEntity.UpdateChannel(channel: y)
            }
            else
            {
                let y = camaraChannel(id: self.tag, ultrixId: idUltrix, nombre: self.titleLabel?.text ?? "", robotId: idPanasonic, xPoint: Float(loc.x), yPoint: Float(loc.y),hidden: false)
                CamaraEntity.saveChannel(camara: y)
            }
//            guard let v = pan.view, let sv = v.superview else { return }
//            if pan.state == .changed {
//                    let pt: CGPoint = pan.location(in: sv)
//                    let xOff = pt.x - sv.center.x
//                    let yOff = pt.y - sv.center.y
//                    // update the .constant values for the btn center x/y
//                    xConstraint.constant = xOff
//                    yConstraint.constant = yOff
//                }
        }
    }
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if UserDefaults.standard.bool(forKey: "config")
        {
        print("longpressed",sender.view?.tag)
            delegate?.openButtonConfig(boton: self)
        }
//           delegate?.selectedSourceButton(tag: sender.view?.tag ?? 0, boton: self)
       }
    @objc func controlPressed(_ sender : UIButton)
    {
        debugPrint(self.constraints.count)
        if !UserDefaults.standard.bool(forKey: "config")
        {
            
        httpRequest()
        socketRequest()
            
        if !presionado
        {
            if UserDefaults.standard.bool(forKey: "panaStats")
            {
                sender.backgroundColor = UIColor(red: 195/255, green: 24/255, blue: 53/255, alpha: 1)
                sender.layer.borderColor = UIColor(red: 231/255, green: 25/255, blue: 76/255, alpha: 1).cgColor
            if let add = UserDefaults.standard.string(forKey: "panasonic")
            {
            let url = "http://\(add)/cgi-bin/aw_cam?cmd=XCN:01:\(self.idPanasonic)&res=1"
            var httpResponseCode : Int = 0
            var requestParams = URLRequest(url: URL(string: url)!)
            requestParams.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: requestParams) {(data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    httpResponseCode = httpResponse.statusCode
                    debugPrint(httpResponse.statusCode)
                }
                print(String(data: data ?? Data(), encoding: .utf8)!)
                
            }
            task.resume()
                
                for x in self.superview!.subviews
                {
                    if let f = x as? CanalButton
                    {
                        if f != self
                        {
                            f.layer.borderColor = UIColor(red: 108/255, green: 127/255, blue: 227/255, alpha: 1).cgColor
                            f.backgroundColor = UIColor(red: 61/255, green: 121/255, blue: 196/255, alpha: 1)
                        }
                    }
                }
        }
            else
            {
                self.superview?.parentContainerViewController?.alerta(message: "Falta las ip", title: "Error")
            }
        }
        }
        }
        
    }
    
    func httpRequest()
    {
        debugPrint(self.superview?.parentContainerViewController)
    }
    func socketRequest()
    {
        if let add = UserDefaults.standard.string(forKey: "ultrix")
        {
            if UserDefaults.standard.bool(forKey: "ultStats")
            {
        let t = self.idUltrix
        DispatchQueue.global(qos: .utility).async {
            
            do
            {
                self.socket = try Socket(.inet, type: .stream, protocol: .tcp)
                let y = try self.socket?.wait(for: .write, timeout: 1, retryOnInterrupt: true)
                debugPrint(y)
                try self.socket?.connect(port: 7788, address: add)
                
                let message = ([UInt8])("XPT I:1 D:\(UserDefaults.standard.integer(forKey: "destiny") + 1) S:\(t) \r\n".utf8)
                try self.socket?.write(message)
                debugPrint("holis")
                //            var buffer = [UInt8](repeating: 0, count: 1500)
                //            try client.read(&buffer, size: 100)
                self.socket?.close()
                debugPrint("holis")
                
            }
            catch
            {
                self.socket?.close()
                debugPrint(error)
                DispatchQueue.main.async {
                    self.backgroundColor = .lightGray
                }
            }
        }
        }
        }

    }
    
}
