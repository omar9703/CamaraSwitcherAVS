//
//  GeneralConfigViewController.swift
//  CamaraSwitcherAVS
//
//  Created by Omar Campos on 10/10/22.
//

import UIKit

protocol PickerImageDelegate {
    func imagenSeleccionado(imagen : UIImage?)
    func ipChanged()
    func dismissConfig()
}

class GeneralConfigViewController: UIViewController,  UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    @IBOutlet weak var collection: UICollectionView!
    var imagen = ""
    var pa : String?
    var ul : String?
    var imagePicker = UIImagePickerController()
    var delegate : PickerImageDelegate?
    var canales = [camaraChannel]()
    @IBOutlet weak var imagenFondo: UIImageView!
    @IBOutlet weak var ipPanasonicField: UITextField!
    @IBOutlet weak var ipUltrixField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.register(UINib(nibName: "BotonesOcultosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        canales = CamaraEntity.getCanales() ?? [camaraChannel]()
        canales = canales.filter({$0.hidden == true})
        // Do any additional setup after loading the view.
    }
    @IBAction func ImagePicker(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pa = UserDefaults.standard.string(forKey: "panasonic")
        {
            ipPanasonicField.text = pa
        }
        if let ul = UserDefaults.standard.string(forKey: "ultrix")
        {
            ipUltrixField.text = ul
        }
    }
    
    @IBAction func CloseAction(_ sender: UIButton) {
        if imagen != ""
        {
            delegate?.imagenSeleccionado(imagen: imagenFondo.image)
            
                guard let data = imagenFondo.image?.jpegData(compressionQuality: 0.5) else { return }
                let encoded = try! PropertyListEncoder().encode(data)
                UserDefaults.standard.set(encoded, forKey: "KEY")
            
            
        }
        if ipPanasonicField.text != "" && ipUltrixField.text != ""
        {
            if validateIpAddress(ipToValidate: ipPanasonicField.text!) && validateIpAddress(ipToValidate: ipUltrixField.text!)
            {
                UserDefaults.standard.set(ipPanasonicField.text!, forKey: "panasonic")
                UserDefaults.standard.set(ipUltrixField.text!, forKey: "ultrix")
                if pa != ipPanasonicField.text || ul != ipUltrixField.text
                {
                    delegate?.ipChanged()
                }
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                self.alerta(message: "Formato no valido", title: "Error")
            }
        }
        else
        {
            self.alerta(message: "faltan datos por llenar.", title: "Error")
        }
        delegate?.dismissConfig()
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
                    fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        if let url = info[.imageURL]
        {
            debugPrint((url as! URL).absoluteString)
//            let fileUrl = URL(fileURLWithPath: url as! String)
            do
            {
                let imageData = try Data(contentsOf: url as! URL)
                imagenFondo.image = UIImage(data: imageData)
                imagen = (url as! URL).absoluteString
//                self.imagenFondo = imageData
            }
            catch
            {
                debugPrint(error)
            }
            
        }
//        imageCanal.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    func validateIpAddress(ipToValidate: String) -> Bool {

        var sin = sockaddr_in()
        var sin6 = sockaddr_in6()

        if ipToValidate.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1 {
            // IPv6 peer.
            return true
        }
        else if ipToValidate.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
            // IPv4 peer.
            return true
        }

        return false;
    }
}

extension UIViewController
{
    
    func alerta(message: String, title: String = "") {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let OKAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
      alertController.addAction(OKAction)
      self.present(alertController, animated: true, completion: nil)
    }
}
extension GeneralConfigViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return canales.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? BotonesOcultosCollectionViewCell else
        {
         return UICollectionViewCell()
        }
        cell.canal = canales[indexPath.row]
        cell.canalLabel.text = "Canal " + "\(canales[indexPath.row].id ?? 0)"
        cell.switcher.isOn = canales[indexPath.row].hidden
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
}
