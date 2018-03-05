//
//  DetailViewController.swift
//  04_Eateries
//
//  Created by Admin on 20.01.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit


// в Main.storyboard необходимо перетянуть "резинку" с Table View на Detail View Controller, таким образом указав Table View, что именно этот класс будет реализовывать все методы его протоколов
class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    var restaurant: Restaurant?
    
    
    // сюда возвращаются с экрана RateViewController
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        
        guard let sourceVC = segue.source as? RateViewController else { // если источник это какой-то другой вьюконтроллер - выходим
            return
        }
        guard let rating = sourceVC.restRating else{ // если rating == nill - выходим
            return
        }
        rateButton.setImage(UIImage(named: rating), for: .normal)
        
        // сохраняем!!
        restaurant?.smile = rating
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext{
            do {
                try context.save()
                print("Сохранение удалось")
            }
            catch let error as NSError {
                print("Не удалось сохранить данные \(error), \(error.userInfo)")
            }
        }
        
    }

    
    
    
    
    // прячем навбар - метод срабатывает раньше, чем загружается viewDidLoad()
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        // добавляем немного декораци для кнопки rateButton и mapButton
        let buttonsArr = [rateButton, mapButton]
        
        for button in buttonsArr {
            guard let button = button else {break} // опциональный анбиндинг - извлекаем button в новую button
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        }
        
        tableView.estimatedRowHeight = 38 // ожидаемая(минимальная) высота ячейки
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // подгружаем картинку из переданного экземпляра
//        imageView.image = UIImage(named: restaurant!.imageName) // картинка со стринги
        imageView.image = UIImage(data: restaurant!.image! as Data) // картинка с бинаридаты
        
        // tableView - это тот что на строке 17
        tableView.backgroundColor = #colorLiteral(red: 0.9396317485, green: 0.9358695466, blue: 0.9888927633, alpha: 1)
        tableView.separatorColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        // избавляемся от пустых ячеек
        tableView.tableFooterView = UIView(frame: CGRect.zero) // говорим, что футер должен быть 0-вого размера
        
        title = restaurant!.name
        
        
        rateButton.setImage(UIImage(named: (restaurant?.smile)!), for: .normal)
        
    }

    
    
    // задание кол-ва секций в tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // создание ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell2", for: indexPath) as! DetailTableViewCell
        
        // теперь можем обращаться к нашим полям key и value
        switch indexPath.row {
        case 0:
            cell.keyLabel.text = "Название"
            cell.valueLabel.text = restaurant!.name
        case 1:
            cell.keyLabel.text = "Тип"
            cell.valueLabel.text = restaurant!.type
        case 2:
            cell.keyLabel.text = "Адрес"
            cell.valueLabel.text = restaurant!.location
        case 3:
            cell.keyLabel.text = "Чи я там бував ранiше?"
            cell.valueLabel.text = restaurant!.isVisited ? "Да" : "Неа"
        default:
            break
        }
        
        // делаем ячейки прозрачного цвета
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
    // указываем кол-во рядов в 1 секции
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mapSegue"{
            let destinationVC = segue.destination as! MapViewController // создаем конст. которая и есть MapViewController
            destinationVC.restaurant = self.restaurant
        }
    }
    
    
 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
