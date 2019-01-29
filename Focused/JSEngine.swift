//
//  JSEngine.swift
//  Focused
//
//  Created by Nikita Semenov on 29/01/2019.
//  Copyright © 2019 Ronte. All rights reserved.
//

import UIKit
import WebKit

class JSEngine: NSObject {
    private weak var webView: WKWebView?
}

extension JSEngine {
    func fire(withWebView webView: WKWebView) {
        self.webView = webView
        webView.configuration.userContentController.add(self, name: "jsHandler")
    }
    
    func pass(text: String) {
        print("sending to web view = \(text)")
        loadToWebView(jsonString: "setValue('\(text)');")
    }
}

extension JSEngine: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "jsHandler" {
            print("recieved message - \(message.body)")
        }
    }
}

extension JSEngine {
    private func loadToWebView(jsonString: String, completion: (()-> Void)? = nil) {
        print("load \(jsonString )")
        webView?.evaluateJavaScript(jsonString, completionHandler: { (any, error) in
            guard let evaluateError = error else {
                print("load jsonString success - \(any ?? "no_response")")
                
                guard let comletionHandler = completion else { return }
                comletionHandler()
                return
            }
            print("load jsonString  error - \(evaluateError.localizedDescription)")
        })
    }
}

