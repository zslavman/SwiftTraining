//
//  PageVC.swift
//  04_Eateries
//
//  Created by Admin on 21.02.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {

    
    var headersArray = ["Записывайте", "Находите"]
    var subheadersArray = ["Создайте спиоск своих любимых кафешек", "Отметьте на карте ваши любимые кафешечки"]
    var imagesArray = ["food", "iphoneMap"]
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        dataSource = self
        
        if let firstVC = displayViewController(atIndex: 0){
            // метод для загрузки вьюконтроллеров
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

    
    
    func displayViewController(atIndex index: Int ) -> ContentVC?{
        
        //вьюконтроллер будет отображаться лишь если index наход. в пределах [0, headersArray.count]
        guard index >= 0 else { return nil}
        guard index < headersArray.count else { return nil}
        
        guard let contentViC = storyboard?.instantiateViewController(withIdentifier: "contentVC") as? ContentVC else{ return nil }
        contentViC.imageFile = imagesArray[index]
        contentViC.header = headersArray[index]
        contentViC.subheader = subheadersArray[index]
        contentViC.index = index
        
        return contentViC
        
    }

    
    func nextVC(atIndex index:Int){
        
        // пробуем вызвать следующий вьюконтроллер
        if let contentVC = displayViewController(atIndex: index + 1){
            setViewControllers([contentVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    

}




// для перемещения по страницах подписываемся на
extension PageVC: UIPageViewControllerDataSource{
    
    //как будет меняться индекс когда листаем вперед
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentVC).index
        index -= 1
        return displayViewController(atIndex: index)
    }
    
    
    //как будет меняться индекс когда листаем назад
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        var index = (viewController as! ContentVC).index
        index += 1
        return displayViewController(atIndex: index)
    }
    
    
//    // кол-во слайдов
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return headersArray.count
//    }
//    
//    // индекс текущего слайда
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        let contentViewC = storyboard?.instantiateViewController(withIdentifier: "contentVC") as? ContentVC
//        return contentViewC!.index
//    }
    
    // в родном индикаторе страниц (в виже точек) все печально, потому создадим свой кастомный индикатор страниц, перетащив на сториобард элемент Page Control
    
    
    
    
    
    
    
    
    
    
}













