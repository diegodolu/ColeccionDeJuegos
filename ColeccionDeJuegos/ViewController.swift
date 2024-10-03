    //
    //  ViewController.swift
    //  ColeccionDeJuegos
    //
    //  Created by Diego Bejarano on 2/10/24.
    //

    import UIKit

    class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return juegos.count
        }
        

        @IBOutlet weak var tableView: UITableView!
        var juegos: [Juego] = []
        
        // -------------------------------------- Función viewWillAppear --------------------------------------
        
        override func viewWillAppear(_ animated: Bool) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                try juegos = context.fetch(Juego.fetchRequest())
                tableView.reloadData()
            } catch {
            }
        }
        
        // -------------------------------------- Función cellForRowAt --------------------------------------
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
                let juego = juegos[indexPath.row]
                cell.textLabel?.text = "\(juego.titulo ?? "") - \(juego.categoria ?? "")"
                cell.imageView?.image = UIImage(data: (juego.imagen!))
                return cell
        }
        
        // -------------------------------------- Función didSelectRowAt --------------------------------------
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let juego = juegos[indexPath.row]
            performSegue(withIdentifier: "juegoSegue", sender: juego)
        }
        
        // -------------------------------------- Función prepare --------------------------------------
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let siguienteVC = segue.destination as! JuegosViewController
            siguienteVC.juego = sender as? Juego
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            if editingStyle == .delete {
                // 1. Eliminar el curso del modelo de datos
                let juego = juegos[indexPath.row]
                juegos.remove(at: indexPath.row)
                // 2. Eliminar la fila de la tabla con una animación
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                context.delete(juego)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        }
        
        func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
            let juego = juegos[indexPath.row]
            guard let imageData = juego.imagen, let image = UIImage(data: imageData) else { return [] }
            let itemProvider = NSItemProvider(object: image)

            let dragItem = UIDragItem(itemProvider: itemProvider)
            return [dragItem]
        }
        
        func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let juegoMovido = juegos.remove(at: sourceIndexPath.row)
            juegos.insert(juegoMovido, at: destinationIndexPath.row)
        }
        
        func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
            let destinationIndexPath: IndexPath
            if let indexPath = coordinator.destinationIndexPath {
                destinationIndexPath = indexPath
            } else {
                destinationIndexPath = IndexPath(row: juegos.count, section: 0)
            }

            // Reordenar los elementos en el modelo de datos
            coordinator.items.forEach { dropItem in
                guard let sourceIndexPath = dropItem.sourceIndexPath else { return }
                
                tableView.performBatchUpdates({
                    let juegoMovido = juegos.remove(at: sourceIndexPath.row)
                    juegos.insert(juegoMovido, at: destinationIndexPath.row)
                    tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
                })
            }
        }


        
        
        // -------------------------------------- Función viewDidLoad --------------------------------------
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.dragDelegate = self
            tableView.dropDelegate = self
            tableView.dragInteractionEnabled = true
        }


    }

