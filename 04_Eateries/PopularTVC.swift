//
//  PopularTVC.swift
//  04_Eateries
//
//  Created by Admin on 04.03.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import ImageIO


class PopularTVC: UITableViewController {
    
    
    var someNames = "Запись "
    let secur:String = "http://zslavman.esy.es/imgdb/sri_"
    var somePics:Array<String> = []
    var spiner:UIActivityIndicatorView!
//    var cache = NSCache<Any, AnyObject>()
    var cache = NSCache<AnyObject, AnyObject>()
    
    var DB = [Data?](repeatElement(nil, count: 15))
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // избавляемся от пустых ячеек
        tableView.tableFooterView = UIView(frame: CGRect.zero) // говорим, что футер должен быть 0-вого размера
        
        // перевести операции в основной поток (из фонового, который по умолчанию)
        //        DispatchQueue.main.async {
        //            self.tableView.reloadData()
        //        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchImages()
        
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
        return DB.count
    }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularCell", for: indexPath)
        addSpiner(toItem: cell.imageView!)
        
        if let baza = DB[indexPath.row]{
            cell.textLabel?.text = readEXIF(indexPath.row)
            cell.imageView?.image = UIImage(data: baza)
            spiner.stopAnimating()
        }
        else {
            // по умолчанию загружаем картинку из проекта
            cell.textLabel?.text = someNames + String(indexPath.row)
            cell.imageView?.image = UIImage(named: "photo")
        }
        
        // закруглим изображения
        cell.imageView?.layer.cornerRadius = 10 // аля маска
        cell.imageView?.clipsToBounds = true // обрезаем изображение по лэеру
        
        if cell.isSelected{
            cell.contentView.backgroundColor = #colorLiteral(red: 0.721867955, green: 0.7081359182, blue: 0.9016706576, alpha: 1)
        }
        
        return cell
    }
    
    
    
    
    
    

    // Получение картинок с сервера
    func fetchImages() -> Void{
        
        for i in 0..<15{
            
            var link:String = secur + String(i) + ".jpg"
           
            if i < 10 {
                link = secur + "0" + String(i) + ".jpg"
            }

            if let url = URL(string: link){
                URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
                    do{
                        let imgData = try Data(contentsOf: url)
                        
                        self.DB[i] = imgData

                        OperationQueue.main.addOperation({
                            self.tableView.reloadData()
                        })
                    }
                    catch{
                        print(error.localizedDescription)
                    }
  
                }).resume()
            }
            else {
                print("Не удается загрузить: \(link)")
            }

            
            
        }
    }
                
    
    
    
    

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = #colorLiteral(red: 0.721867955, green: 0.7081359182, blue: 0.9016706576, alpha: 1)
        
        
    }
    
    
    
    
    
    // чтение EXIF
    func readEXIF(_ numOfCell:Int) -> String{
        
        if let imageSource = CGImageSourceCreateWithData(DB[numOfCell] as! CFData, nil) {
            let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as! NSDictionary
           
            // дата съемки
            let exifModel_ = imageProperties.value(forKey: "{Exif}") as! NSDictionary
            let dateTimeOriginal = exifModel_.value(forKey:kCGImagePropertyExifDateTimeOriginal as String) as! NSString
            
            // модель фотика
//            let tiffModel_ = imageProperties.value(forKey: "{TIFF}")
//            let cameraModel = (tiffModel_ as AnyObject).value(forKey: kCGImagePropertyTIFFModel as String) as! NSString
            
            var str = dateTimeOriginal as String
            str = str.replacingOccurrences(of: " ", with: " - ")
            
            return str
            
        }
        return "- - -"
    }
    
    
    
    
    
    
    
}















