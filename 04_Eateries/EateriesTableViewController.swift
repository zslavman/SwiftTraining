//
//  EateriesTableViewController.swift
//  04_Eateries
//
//  Created by Admin on 14.01.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreData


class EateriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    
//    var someNames = ["Марадон", varулебякин", "Джун", "Шмякс", "Трякс", "Куня", "Зиба", "Вороба", "Бодитан", "Леминг", "Лушпак", "Кеды", "Козуб", "Дуря", "Ремминг Буболеховое Счастье нога-лицо"]
//    var somePics = ["ogonek.jpg", "elu.jpg", "bonsai.jpg", "dastarhan.jpg", "indokitay.jpg", "x.o.jpg", "balkan.jpg", "respublika.jpg", "speakeasy.jpg", "morris.jpg", "istorii.jpg", "klassik.jpg", "love.jpg", "shok.jpg", "bochka.jpg"]
//    var visitedItems = [Bool](repeatElement(false, count: 15))
    
    var fetchResultsController:NSFetchedResultsController<Restaurant>!
    var searchController: UISearchController!
    var filteredResultArray: [Restaurant] = []
    var restaurants: [Restaurant] = []
    
    
    
    // создадим массив структур Restaurant
//        Restaurant(name: "Марадон", type: "ресторан", location: "Пемза, бульвар Вацлава Гавела, 07 ля-ля-ля-ля-ля-ля-ля-ля лоылоповылп олывоп", imageName: "ogonek.jpg", isVisited: false),
//        Restaurant(name: "Елуп", type: "забегаловка", location: "Уфа", imageName: "elu.jpg", isVisited: false),
//        Restaurant(name: "Трякс", type: "кафешка", location: "Пирятин", imageName: "bonsai.jpg", isVisited: false),
//        Restaurant(name: "Дастархан", type: "харчевня", location: "Жданск", imageName: "dastarhan.jpg", isVisited: false),
//        Restaurant(name: "Херос", type: "фастфуд", location: "Милитополь", imageName: "indokitay.jpg", isVisited: false),
//        Restaurant(name: "Джун", type: "ресторан-клуб", location: "Воронеш", imageName: "x.o.jpg", isVisited: false),
//        Restaurant(name: "Бодитан", type: "столовая", location: "Оклахома", imageName: "balkan.jpg", isVisited: false),
//        Restaurant(name: "Казантип", type: "полустоловая", location: "КанзасСити", imageName: "respublika.jpg", isVisited: false),
//        Restaurant(name: "Спек", type: "ресторанный комплекс", location: "ДНР-нах", imageName: "speakeasy.jpg", isVisited: false),
//        Restaurant(name: "Шмякс", type: "забегаловка", location: "Офшоры", imageName: "morris.jpg", isVisited: false),
//        Restaurant(name: "Куня", type: "ресторан", location: "Мумбаи", imageName: "istorii.jpg", isVisited: false),
//        Restaurant(name: "Классик", type: "рЕСТОРАН", location: "Дубаи", imageName: "klassik.jpg", isVisited: false),
//        Restaurant(name: "Лушпак", type: "ресторан", location: "Перенеи", imageName: "love.jpg", isVisited: false),
//        Restaurant(name: "Шок", type: "киоск", location: "Котманду", imageName: "shok.jpg", isVisited: false),
//        Restaurant(name: "Ремминг", type: "дыра", location:  "Кот-де-Ивур", imageName: "bochka.jpg", isVisited: false)]
    
    
    
    @IBAction func closeSegue(segue: UIStoryboardSegue){ }
    
    
    
    

    
    
    // прячем навбар. Метод viewWillAppear - срабатывает раньше, чем загружается viewDidLoad()
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }
    

    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        // передаем нил, чтоб результаты отображались в главном экране (на том, котором будет поисковая панель)
        searchController = UISearchController(searchResultsController: nil)
        
        // указываем, какой контроллер будет обновлять результаты поиска
        // обязательно нужно подписаться под протокол UISearchResultsUpdating чтоб работало!
        searchController.searchResultsUpdater = self
        
        // для соблюдения протокола UISearchBarDelegate
        searchController.searchBar.delegate = self
        
        //отключаем затемнение вьюконтроллера при вводе
        searchController.dimsBackgroundDuringPresentation = false
        // не разрешаем прятать навбар при фокусе в поле поиска
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.721867955, green: 0.7081359182, blue: 0.9016706576, alpha: 1) // цвет самой панели
        searchController.searchBar.tintColor = .black
        searchController.searchBar.placeholder = "Название ресторана"
        
        tableView.tableHeaderView = searchController.searchBar

        // чтоб searchController не переходил на другие экраны (детайлвьюконтроллер)
        definesPresentationContext = true

        
//        tableView.estimatedRowHeight = 85
//        tableView.rowHeight = UITableViewAutomaticDimension
        
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // NSFetchRequest<Restaurant> - это дженерик с типом Restaurant. fetchRequest() - это статический метод класса Restaurant
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        // создадим дискриптор, который выведет отстортированные данные по полю name, в порядке увеличения
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor] // sortDescriptor - фильтр, который мы создали сверху
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext{
            
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            // подписываемся под реализацию методов NSFetchedResultsControllerDelegate
            fetchResultsController.delegate = self

            do {
                try fetchResultsController.performFetch()
                // если все ок - заполняем его объектами, которые получаем через fetchResultsController
                restaurants = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
   
    }
    
    
    
    // метод вызовется сразу после viewDidLoad
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)

        // получаем доступ к хранилищу настроек по умолчанию
        let userDefaults = UserDefaults.standard
        // проверяем есть ли в хранилище ключ wasIntroWatched и получаем его значение
        let wasIntroWatched = userDefaults.bool(forKey: "wasIntroWatched")
        // если значение wasIntroWatched == false продолжаем выполнять код далее
        guard !wasIntroWatched else { return }
        
        // переход на PageVC (вместо segue)
        if let pageViewC = storyboard?.instantiateViewController(withIdentifier: "pageVC") as? PageVC{
            present(pageViewC, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    
    
    
    // MARK: - назначаем делегата fetchResultsController
    // сработает перед тем, как контроллер поменяет свой контент
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    
    
    
    // при любых изменениях с данными сработает это
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type:
        NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: guard let indexPath = newIndexPath else {break}
            tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = indexPath else {break}
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = indexPath else {break}
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    
    
    
    
    // MARK: - источник данных tableView
    
    //**************************
    // 2 обязательных метода!! *
    //**************************
    
    // определяем количество секций в tableView
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    
    
    // создаем ячейку
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // применим для конкретной ячейки наш класс (кастить)
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! EateriesTableViewCell
        
        // выбираем источни
        let restaurant = restaurantToDisplay(indexPath: indexPath)

        cell.thumbnailImageView.image = UIImage(data: restaurant.image! as Data) // картинка в качестве бинариДата
        // закруглим изображения
        cell.thumbnailImageView.layer.cornerRadius = 10 // аля маска
        cell.thumbnailImageView.clipsToBounds = true // обрезаем наше изображение по лееру
        
        // заполняем поля
        cell.nameLabel.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        
        // заполняем ячейку (галочка/пусто)
        cell.accessoryType = restaurant.isVisited ? .checkmark : .none
        
        return cell
    }

    
    
    
    // указываем кол-во рядов в 1 секции
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searchController.isActive && searchController.searchBar.text != ""{
          return filteredResultArray.count
        }
        return restaurants.count
    }

    
    
    
    
//    // клик по ячейке
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        // основной алертконтроллер в виде шита
//        let alertController = UIAlertController(title: nil, message: "Выберите действие:", preferredStyle: .actionSheet)
//        // .actionSheet - когда окно сообщения всплывает снизу экрана (вн12изу и остается)
//        // .alert - когда окно появляется по центру (более похоже на оповещение)
//        
//        // 1-й экшн (позвонить)
//        let call = UIAlertAction(title: "Позвонить: +3(099)370-059\(indexPath.row)", style: .default) {
//            (action: UIAlertAction) -> Void in
//            // 2-й алертконтроллер внутри первого экшена
//            let alertController2 = UIAlertController(title: nil, message: "Вызов невозможен!", preferredStyle: .alert)
//            let act = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertController2.addAction(act)
//            self.present(alertController2, animated: true, completion: nil)// self - потому что внутри блока
//        }
//        
//        let stringTitle = self.restaurants[indexPath.row].isVisited ? "Убрать пометку" : "Пометить галочкой"
//        
//        // 2-й экшн (установка галочки)
//        let isVisited = UIAlertAction(title: stringTitle, style: .default) {
//            (action) in
//            let cell = tableView.cellForRow(at: indexPath)
//            
//            self.restaurants[indexPath.row].isVisited = !self.restaurants[indexPath.row].isVisited
//            cell?.accessoryType = self.restaurants[indexPath.row].isVisited ? .checkmark : .none
//        }
//        
//        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//        
//        // добавляем экшены к основному алертконтроллеру
//        alertController.addAction(call)      // позвонить
//        alertController.addAction(isVisited) // установка галочки "Я был здесь"
//        alertController.addAction(cancel)    // отмена
//        
//        // добавляем на экран
//        present(alertController, animated: true, completion: nil)
//        
//        // избавляемся от выделения ячейки при отпускании пальца
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//    }
    
    
//    // удаление ячейки (даже пустой метод при свайпе показывает возможность удаления)
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == .delete {
//            self.someNames.remove(at: indexPath.row)
//            self.somePics.remove(at: indexPath.row)
//            self.visitedItems.remove(at: indexPath.row)
//        }
//        // перегружаем таблицу (обновляем всю сразу)
//        // tableView.reloadData()
//        
//        // красивое обновление ячейки таблицы после удаления
//        tableView.deleteRows(at: [indexPath], with: .fade)
//    }

    
    // удаление ячейки
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
        // действие на "поделиться"
        let share = UITableViewRowAction(style: .default, title: "Поделиться") {
            (action, indexPath) in
            let defaultText = "Я сейчас в " + self.restaurants[indexPath.row].name!
//            if let image = UIImage(named: self.restaurants[indexPath.row].imageName){ // картинка со стринги
            if let image = UIImage(data: self.restaurants[indexPath.row].image! as Data){ // картинка с банаридаты
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        
        // действие на удаление
        let delete = UITableViewRowAction(style: .default, title: "Удалить") {
            (action, indexPath) in
            self.restaurants.remove(at: indexPath.row)
//            self.someNames.remove(at: indexPath.row)
//            self.visitedItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            
            
            // удаление с БД
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext{
                
                let objectToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(objectToDelete)
                
                do {
                    try context.save()
                }
                catch{
                    print("Не удалось сохранить т.к. \(error.localizedDescription)")
                }
            }
        }
        
        // поменяем цвета кнопок Удалить и Поделиться
        share.backgroundColor = #colorLiteral(red: 0.721867955, green: 0.7081359182, blue: 0.9016706576, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 0.8551122302, green: 0.6081331131, blue: 0.6449473155, alpha: 1)
        
        return [delete, share]
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // если осуществляем переход по сегвею с названием detailSegue
        if segue.identifier == "detailSegue"{
            if let indexPath = tableView.indexPathForSelectedRow{
//                print("это и есть что? - \(self)")
                let destinationVievController = segue.destination as! DetailViewController

                // передаем экземпляр класса
                destinationVievController.restaurant = restaurantToDisplay(indexPath: indexPath)
                
                tableView.deselectRow(at: indexPath, animated: true) // убирем выделение
            }
            
        }
    }
    
    
    
    
    
    
    /// Ф-ция заполняющая отфильтрованный массив
    ///
    /// - Parameter text:  вводимый текст
    func filterContentFor(searchText text:String){
        filteredResultArray = restaurants.filter{ (restaurant) -> Bool in
//            return (restaurant.name?.lowercased().contains(text.lowercased()))!
            if ((restaurant.name?.lowercased().contains(text.lowercased()))! ||
                (restaurant.type?.lowercased().contains(text.lowercased()))! ||
                (restaurant.location?.lowercased().contains(text.lowercased()))!){
                return true
            }
            return false
        }
    }
    
    
    
    
    
//    func filterContent(for searchText: String) {
//        filteredResultArray = restaurants.filter({ (restaurant) -> Bool in
//            if let name = restaurant.name {
//                let isMatch = name.localizedCaseInsensitiveContains(searchText)
//                return isMatch
//            }
//            return false
//        })
//    }
    
    
    
    
    
    
    /// Выбирает источник отображения в зависимости от того задействована ли  строка поиска
    ///
    /// - Parameter indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    func restaurantToDisplay (indexPath:IndexPath) -> Restaurant{
       
        let restaurant:Restaurant
        
        //если активно поле поиска и уже есть введенный текст
        if searchController.isActive && searchController.searchBar.text != ""{
            restaurant = filteredResultArray[indexPath.row]
        }
        else {
            restaurant = restaurants[indexPath.row]
        }
        return restaurant
    }
    

    


}



extension EateriesTableViewController:UISearchResultsUpdating{
    
    // метод срабатывает при любом изменение в поисковом запросе
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
        
    }
}






// для устранения наезжания строки поиска на таблицу когда фокус был на поиске, а кликнули по таблице
extension EateriesTableViewController:UISearchBarDelegate{
    
    // когда щелкнули на поисковую строку
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    
    // после того как фокус ушел с поля поиска
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    
    
    
}








































