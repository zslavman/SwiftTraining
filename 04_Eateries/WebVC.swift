//
//  WebVC.swift
//  04_Eateries
//
//  Created by Admin on 03.03.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import WebKit


class WebVC: UIViewController, WKNavigationDelegate {
    
    
    var webView:WKWebView!
    var progressView:UIProgressView!
    var url: URL!
    
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    
    // удаляем слушателя по уходу из этого экрана
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        //        navigationController?.isToolbarHidden = true
    }
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView // заменяем обычный вью на вэбвью
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        // для пользования свайп влево/ сввайп вправо по истории (страница вперед/страница назад)
        webView.allowsBackForwardNavigationGestures = true
        
        // прогрессбар загрузки страницы
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit() // чтоб прогрессбар занимал предоставленное ему место
        
        // размещаем прогрессбатон вместо одной из кнопок таббара
        let progressButton = UIBarButtonItem(customView: progressView)
        let flexibleSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // разделитель кнопки и полосы загрузки
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        // добавляем все кнопки в массив который есть по умолчанию
        toolbarItems = [progressButton, flexibleSpacer, refreshButton]
        navigationController?.isToolbarHidden = false // чтоб тулбар точно был на экране и не спрятался
        
        // для отображения загрузки в прогрессбаре нужно добавить наблюдателя
        // self - за кем наблюдать
        // #keyPath(webView.estimatedProgress) - свойство за которым будем следить
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
    }
    
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    
    // после загрузки страницы отобразим ее название в тайтле
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    
    
    
    
    
    
    
    
    
}
