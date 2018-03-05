//
//  MapViewController.swift
//  04_Eateries
//
//  Created by Admin on 21.01.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {

    
    var restaurant:Restaurant!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapView.delegate = self // наш класс будет релаизовывать методы делегата mapView
        
        // геокодер преобразовывает текстовый формат адреса в долготу и широту (и в обратную сторону)
        // массив адресов, соотв. адресу
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(restaurant.location!) {
            (placemarks, error) in
            guard error == nil else {return}
            guard let placemarks = placemarks else {return} // если в плейсмаркс извлечется новая константа - продолжаем далее
        
            let placemark = placemarks.first! // берем первое значение в массиве
            
            
            // размещаем на карте табличку(аннотацию) с рестораном
            let annotation = MKPointAnnotation()
            annotation.title = self.restaurant.name
            annotation.subtitle = self.restaurant.type
            
            guard let location = placemark.location else {return}
            // размещаем аннотацию по тем же коорд. что и location
            annotation.coordinate = location.coordinate
            
            // отображаем аннотацию
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true) // разворачивает(показывает) аннотацию
            
        }
        
        
        
    }


    // MKAnnotationView - возвращает просто аннотацию без иголочки
    // MKPinAnnotationView - возвращает аннотацию с иголкой!!
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {return nil} // проверяем, не находимся ли мы в этой точке
        
        let annotationIdentifier = "restAnnotation"
        // метод переиспользования аннотаций, которые ушли за пределы экрана, кастим чтоб появился пин
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true // свойство, позволяющее отображать дополнительную аннотацию
        }
        
        // создаем рамочку, куда поместим нашу аннотацию (annotationView)
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        rightImage.image = UIImage(data: restaurant.image! as Data) //UIImage(named: restaurant.imageName)
        
        annotationView?.rightCalloutAccessoryView = rightImage // в правую часть аннотации помещаем картинку
        
        // меняем цвет иголочки
        annotationView?.pinTintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        
        return annotationView
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
