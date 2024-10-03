//
//  JuegosViewController.swift
//  ColeccionDeJuegos
//
//  Created by Diego Bejarano on 2/10/24.
//

import UIKit

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var tituloTexField: UITextField!
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    @IBOutlet weak var eliminarBoton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var imagePicker = UIImagePickerController()
    var juego:Juego? = nil
    let categorias = ["Acción", "Aventura", "Deportes", "Survival"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if juego != nil {
            ImageView.image = UIImage(data: (juego!.imagen!) as Data)
            tituloTexField.text = juego!.titulo
            
            if let categoria = juego?.categoria, let index = categorias.firstIndex(of: categoria) {
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            
            agregarActualizarBoton.setTitle("Actualizar", for: .normal)
        } else {
            eliminarBoton.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func camaraTapped(_ sender: Any) {
    }
    
    @IBAction func agregarTapped(_ sender: Any) {
        if juego != nil {
            juego!.titulo! = tituloTexField.text!
            juego!.imagen = ImageView.image?.jpegData(compressionQuality: 0.50)
            juego!.categoria = categorias[pickerView.selectedRow(inComponent: 0)]
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juego = Juego(context: context)
            juego.titulo = tituloTexField.text
            juego.imagen = ImageView.image?.jpegData(compressionQuality: 0.50)
            juego.categoria = categorias[pickerView.selectedRow(inComponent: 0)]
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func eliminarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(juego!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenSeleccionada = info[.originalImage] as? UIImage
        ImageView.image = imagenSeleccionada
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // ------------------ picker View ---------------------------
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorias.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorias[row]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
