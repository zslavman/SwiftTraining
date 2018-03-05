//
//  RateViewController.swift
//  04_Eateries
//
//  Created by Admin on 21.01.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var brilliantButton: UIButton!
    var restRating:String?
    
    
    //ф-ция для группы (по Tag'ам) кнопок
    @IBAction func rateRestaurant(sender: UIButton){
        
        switch sender.tag {
            case 0: restRating = "bad"
            case 1: restRating = "good"
            case 2: restRating = "brilliant"
            default: break
        }
        // принудительный переход (возврат)
        performSegue(withIdentifier: "unwindSegueToDVC", sender: sender)
        
    }
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Для анимации!
        // записываем начальные значения кнопок
        badButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        goodButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        brilliantButton.transform = CGAffineTransform(scaleX: 0, y: 0)

        let blurEffect = UIBlurEffect(style: .regular) // создаем размытие
        let blurEffectView = UIVisualEffectView(effect: blurEffect) // применяем размытие
        blurEffectView.frame = self.view.bounds // определяем размер фрейма размытия
        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth] // при переворачивании телефона перерисовываем эффект размытия на весь экран, иначе будет половинчатый эффект
        self.view.insertSubview(blurEffectView, at: 1) // вставляем блюрэффект поверх фона
    }
    
    
    // анимация
    override func viewDidAppear(_ animated: Bool) {
        
//        UIView.animate(withDuration: 0.4) { 
//            self.ratingStackView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        }
        
        let buttonArray = [badButton, goodButton, brilliantButton]
        
        for (index, button) in buttonArray.enumerated() {
            let deley = Double(index) * 0.1 // задержка появления для каждой последующей кнопки
            // usingSpringWithDamping - как будет отскакывать, если = 1 то вообще отскакивать не будет
            // initialSpringVelocity - начальная скорость пружины
            UIView.animate(withDuration: 0.6, delay: deley, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                button?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
        
    }
    


}




















