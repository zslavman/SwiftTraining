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
//    var imageCache = NSCache<NSString, AnyObject>()
    var imageCache = [NSString:AnyObject]()
    
//    var DB = [Data?](repeatElement(nil, count: 15))
    let ELEMENTS_COUNT = 15
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // избавляемся от пустых ячеек
        tableView.tableFooterView = UIView(frame: CGRect.zero) // говорим, что футер должен быть 0-вого размера
        
        // перевести операции в основной поток (из фонового, который по умолчанию)
        //        DispatchQueue.main.async {
        //            self.tableView.reloadData()
        //        }
        
        // дергалка за которую дергаешь а оно обновляется! хопа!
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = .white
        refreshControl?.tintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
    }
        
    

    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("imCount = \(imCount)")
        print("Записей в кэше = \(imageCache.count)")
        if imageCache.count == 0 {
            fetchImages()
        }
    }

    
    
    
    func refresh()->Void{
        imageCache.removeAll()
        imCount = 0
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
        return ELEMENTS_COUNT
    }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularCell", for: indexPath)
        addSpiner(toItem: cell.imageView!)
        
        let link = generateLink(indexPath.row)
        
//        if let cachedImage = imageCache.object(forKey: link as NSString) {
        if imageCache.keys.contains(link as NSString){
            cell.textLabel?.text = readEXIF(indexPath.row)
            cell.imageView?.image = UIImage(data: imageCache[link as NSString] as! Data)
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
    
    
    
    
    
    func generateLink(_ num:Int) -> String{
        
        var link:String = secur + String(num) + ".jpg"
        if num < 10 {
            link = secur + "0" + String(num) + ".jpg"
        }
        return link
    }
    
    
    
    private var imCount:Int = 0

    // Получение картинок с сервера
//    func fetchImages() -> Void{
//        
//        for i in 0..<ELEMENTS_COUNT{
//            
//            let link = generateLink(i)
//
//            if let url = URL(string: link){
//
//                URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
//                    do{
//                        let imgData = try Data(contentsOf: url)
////                        self.imageCache.setObject(imgData as AnyObject, forKey: url.absoluteString as NSString)
//                        self.imageCache.updateValue(imgData as AnyObject, forKey: url.absoluteString as NSString)
//                        
//                        self.imCount += 1
//                        print("Размер картинки:  \(round(Double(data!.count/1000))) Кб, \(self.imCount)/\(self.ELEMENTS_COUNT)")// Размер картинки: 125 Кб, 5/15
//                        
//                        OperationQueue.main.addOperation({
//                            self.tableView.reloadData()
//                            self.refreshControl?.endRefreshing() // завершаем обновление по оттягиванию сверху
//                        })
//                    }
//                    catch{
//                        print(error.localizedDescription)
//                    }
//                    
//                }).resume()
//            }
//            else {
//                print("Не удается загрузить: \(link)")
//            }
//        }
//    }
    
    
    
    
    
    
    public func fetchImages() -> Void{
        
        for i in 0..<ELEMENTS_COUNT{
            
            let link = URL(string: generateLink(i)) // получаем URL
            
            // создаем очередь
            let queue = DispatchQueue.global(qos: .background)
            queue.async { // добавляем процесс в очередь асинхронно
                guard let imgURL = link, let imgData = try? Data(contentsOf: imgURL) else { return } // если link существует (не битый), пытаемся получить данные картинки, иначе выходим
                
                // возвращаемся в основной поток (все обновления интерфейса должны происходить ТОЛЬКО! в основном потоке)
                DispatchQueue.main.async {
                    self.imageCache.updateValue(imgData as AnyObject, forKey: imgURL.absoluteString as NSString)
                    self.imCount += 1
                    
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing() // завершаем обновление по оттягиванию сверху
                }
            }
        }
    }
        
    
    
    
        
        

    
    

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = #colorLiteral(red: 0.721867955, green: 0.7081359182, blue: 0.9016706576, alpha: 1)
        
        
    }
    
    
    
    
    
    // чтение EXIF
    func readEXIF(_ numOfCell:Int) -> String{
        
        let link = generateLink(numOfCell)
//        let imageFromCache = imageCache.object(forKey: link as NSString) // тут не будет nil, т.к. сюда заходим только если эта запись в кэше существует
        let imageFromCache = imageCache[link as NSString]
        
        if let imageSource = CGImageSourceCreateWithData(imageFromCache as! CFData, nil) {
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
    









//extension UIImageView{
//    
//    func loadImageUsingUrlString(urlString: String){
//        
//        let url = URL(string: urlString)
//        
//        image = nil
//        
//        URLSession.shared.dataTask(with: url!) {
//            (data, responses, error) in
//            
//            if error != nil{
//                print(error!)
//                return
//            }
//            
////            dispatch_async(dispatch_get_main_que(), {
////                self.image = UIImage(data: data!)
////            })
//            
//            OperationQueue.main.addOperation({
//                self.image = UIImage(data: data!)
//            })
//            
//        }.resume()
//    }
//}



























