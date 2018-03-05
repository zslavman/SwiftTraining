//
//  ContentVC.swift
//  04_Eateries
//
//  Created by Admin on 21.02.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit


// класс одной страницы
class ContentVC: UIViewController {


    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subheaderLable: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var pageButton: UIButton!
    var header = ""
    var subheader = ""
    var imageFile = ""
    var index = 0 // индекс для вьюконтроллеров пейджвьюконтроллера
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        headerLabel.text = header
        subheaderLable.text = subheader
        imageView.image = UIImage(named: imageFile)
        
        // для кастомной индикации страниц 
        pageControl.numberOfPages = 2
        pageControl.currentPage = index
        
        // настраиваем кнопку
        pageButton.layer.cornerRadius = 15
        pageButton.clipsToBounds = true
        pageButton.layer.borderWidth = 2
        pageButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        pageButton.layer.borderColor = (#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)).cgColor
        
        // тексты для кнопки для различных страниц пейджвьюконтроллера
        switch index {
        case 0: pageButton.setTitle("Дальше", for: .normal)
        case 1: pageButton.setTitle("Открыть", for: .normal)
        default:
            break
        }
        
    }
    
    
    

    @IBAction func onPageBttnClick(_ sender: UIButton) {
        
        switch index {
        case 0:
            let pageVC = parent as! PageVC
            pageVC.nextVC(atIndex: index)
        case 1:
            // получаем доступ к хранилищу настроек по умолчанию
            // в хранилице храняться ключи, которые мы сами придумываем
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "wasIntroWatched")
            userDefaults.synchronize()
            
            dismiss(animated: true, completion: nil)
        default:
            break
        }
        
        
    }
    
    
    
    
    
    
    


}











