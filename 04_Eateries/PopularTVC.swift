//
//  PopularTVC.swift
//  04_Eateries
//
//  Created by Admin on 04.03.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class PopularTVC: UITableViewController {
    
    
    var someNames = ["Марадон", "лебякин", "Джун", "Шмякс", "Трякс", "Куня", "Зиба", "Вороба", "Бодитан", "Леминг", "Лушпак", "Кеды", "Козуб", "Дуря", "Ремминг Буболеховое Счастье нога-лицо"]
    var somePics = ["ogonek.jpg", "elu.jpg", "bonsai.jpg", "dastarhan.jpg", "indokitay.jpg", "x.o.jpg", "balkan.jpg", "respublika.jpg", "speakeasy.jpg", "morris.jpg", "istorii.jpg", "klassik.jpg", "love.jpg", "shok.jpg", "bochka.jpg"]
    var spiner:UIActivityIndicatorView!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // избавляемся от пустых ячеек
        tableView.tableFooterView = UIView(frame: CGRect.zero) // говорим, что футер должен быть 0-вого размера
        
        // перевести операции в основной поток (из фонового, который по умолчанию)
        //        DispatchQueue.main.async {
        //            self.tableView.reloadData()
        //        }
    }
    
    
    
    
    
    
    /// Добавляет спинер
    ///
    /// - Parameter target: к чему прицепить спинер
    func addSpiner(toItem target:AnyObject) -> () {
        
        spiner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        //        spiner.color = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        spiner.translatesAutoresizingMaskIntoConstraints = false // не позволяем xcode управлять констрейнами и авторесайзом
        spiner.hidesWhenStopped = true // прячем когда остановиться
        spiner.startAnimating()
        target.addSubview(spiner)
        
        // spiner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        // spiner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        
        // альтернативный метод размещения
        NSLayoutConstraint(item: spiner, attribute: .centerX, relatedBy: .equal, toItem: target, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: spiner, attribute: .centerY, relatedBy: .equal, toItem: target, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return someNames.count
    }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularCell", for: indexPath)
        cell.textLabel?.text = someNames[indexPath.row]
        cell.imageView?.image = UIImage(named: somePics[indexPath.row])
        
        // закруглим изображения
        cell.imageView?.layer.cornerRadius = 10 // аля маска
        cell.imageView?.clipsToBounds = true // обрезаем изображение по лэеру
        
        if cell.isSelected{
            cell.contentView.backgroundColor = #colorLiteral(red: 0.721867955, green: 0.7081359182, blue: 0.9016706576, alpha: 1)
        }
        
        addSpiner(toItem: cell.imageView!)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = #colorLiteral(red: 0.721867955, green: 0.7081359182, blue: 0.9016706576, alpha: 1)
        //        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
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
