//
//  AboutTVC.swift
//  04_Eateries
//
//  Created by Admin on 25.02.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class AboutTVC: UITableViewController {

    let sectionHeaders = ["Я в соцсетях", "Мой сайт"]
    let sectionContent = [["facebook", "vk", "youtube"], ["zslavman.zzz.com.ua", "zslavman.esy.es"]] // массив названий
    let links = [["https://www.facebook.com/zslavman", "https://vk.com/zslavman", "https://goo.gl/vjMX4g"], ["http://www.zslavman.zzz.com.ua", "http://www.zslavman.esy.es"]] // массив ссылок названий
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // избавляемся от лишних строк таблицы
        tableView.tableFooterView = UIView(frame: .zero)
        title = "Обо мне!"
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    
    // озаглавливание строк таблицы
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContent[section].count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath)
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]

        return cell
    }

    
    
    
    
    // снимаем выделение
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        switch indexPath.section {
//        case 0:
//            switch indexPath.row {
//            case 0..<links.count:
//                performSegue(withIdentifier: "showWebPageSegue", sender: self)
//            default: break
//            }
//            
//        default: break
//        }
        
        performSegue(withIdentifier: "showWebPageSegue", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showWebPageSegue"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let destin_vc = segue.destination as! WebVC
//                destin_vc.url = URL(string: links[indexPath.row])
                destin_vc.url = URL(string: links[indexPath.section][indexPath.row])
            }
        
        }
    }
    
    
    
    
    
    
    
    
    
    
    


    
    
    


}
