//
//  AddCell_TVC.swift
//  04_Eateries
//
//  Created by Admin on 23.01.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit



// для реализациии выбора фото, подписываемся под 2-мя протоколами
class AddCell_TVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var adresTF: UITextField!
    @IBOutlet weak var typeTF: UITextField!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    var isVisited:Bool = false
    
    // нажали на
    @IBAction func togleIsVisitedPressed(_ sender: UIButton) {
        
        if sender == yesButton{
            sender.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            noButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            isVisited = true
        }
        else {
            sender.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            yesButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            isVisited = false
        }
    }
    
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        if nameTF.text == "" || adresTF.text == "" || typeTF.text == ""{
            let alertController = UIAlertController(title: nil, message: "Не все поля заполнены!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(ok)
            present(alertController, animated: true, completion: nil)
        }
        else {
            // написав все что в скобочке - мы получили доступ к AppDelegate и ко всем его методам
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext{
                let restaurant = Restaurant(context: context)
                restaurant.name = nameTF.text
                restaurant.location = adresTF.text
                restaurant.type = typeTF.text
                restaurant.isVisited = isVisited
                if let image = imageView.image{
                    // т.к. нам нужна бинарная дата нужно кастить до НСДата
                    restaurant.image = UIImagePNGRepresentation(image) as NSData? // в Swift4 "as NSData?" больше писать не нужно
                }
                do {
                    try context.save()
                    print("Сохранение удалось")
                }
                catch let error as NSError {
                    print("Не удалось сохранить данные \(error), \(error.userInfo)")
                }
            }
            
            performSegue(withIdentifier: "unwindSegueFromNew", sender: self)
        }
        
    }
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        yesButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        noButton.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)

    
    }


    // действие при выборе конкртеного изображения
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true // все что выходит за рамки супервью - обрезается
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    // override так как базовый функционал у нас уже есть
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            let alertController = UIAlertController(title: "Источник фотографии", message: nil, preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Камера", style: .default) {
                (action) in
                self.chooseImagePicerAction(source: .camera)
            }
            let photoLibAction = UIAlertAction(title: "Фото", style: .default) {
                (action) in
                self.chooseImagePicerAction(source: .photoLibrary)
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            alertController.addAction(cameraAction)
            alertController.addAction(photoLibAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true) // снимаем выделение с ячейки
    }
    
    
    
    
    
    // запускает либо камеру либо библиотеку
    func chooseImagePicerAction(source: UIImagePickerControllerSourceType){
        
        // проверяем, доступен ли данный контроллер на устройстве (камера или библиотека)
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            
            // ДЛЯ СООТВЕТСТВИЯ ПРОТОКОЛУ!
            imagePicker.delegate = self
            
            imagePicker.allowsEditing = true // когда делаем снимок можно уменьшать/обрезать
            imagePicker.sourceType = source // именно тут переключаемся на камеру или на библиотеку
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    
    
    


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
