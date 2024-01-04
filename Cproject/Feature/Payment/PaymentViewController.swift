//
//  PaymentViewController.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/04.
//

import UIKit
import WebKit

final class PaymentViewController: UIViewController {
    
    private var webView: WKWebView?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView?.load(URLRequest(url: URL(string: "https://google.co.kr")!))
    }
}

#Preview {
    PaymentViewController()
}
