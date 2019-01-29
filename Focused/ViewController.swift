//
//  ViewController.swift
//  Focused
//
//  Created by Nikita Semenov on 29/01/2019.
//  Copyright © 2019 Ronte. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet weak var proxyTextField: UITextField!
    
    private let jsEngine = JSEngine()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeOnKeyboardEvents()
        loadData()
    }
    
    @IBAction func proxyTextFieldEditingChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        jsEngine.pass(text: text)
    }
}

extension ViewController {
    private func subscribeOnKeyboardEvents() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
}

extension ViewController {
    private func loadData() {
        guard let url = Bundle.main.url(forResource: "index", withExtension: "html") else { return }
        jsEngine.fire(withWebView: webView)
        webView.load(URLRequest(url: url))
    }
}

extension ViewController {
    @objc func keyboardWillShow(notification: Notification) {
        webView.resignFirstResponder()
        if !proxyTextField.isFirstResponder {
            proxyTextField.becomeFirstResponder()
        }
    }
}

