//
//  SigninViewController.swift
//  Nber
//
//  Created by Apple on 02/06/2023.
//

import UIKit
import WebKit

class AuthViewController: UIViewController,WKNavigationDelegate{
    
    private let webView:WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config  = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration:config)
        
        return webView
    }()
    
    public var completionHandler:((Bool)-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        
         guard let url = AuthManager.shared.signedURL else {return}
         let request = URLRequest(url: url)
         webView.load(request)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        print(url.absoluteString)
        
        // Extract the authorization code from the redirect URL
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else { return }
        
        print("code:\(code)")
        webView.isHidden = true
        
        AuthManager.shared.exchangeCodeForToken(code: code) {[weak self] sucess in
            DispatchQueue.main.async {[weak self] in
                self?.navigationController?.popToRootViewController(animated: false)
                self?.completionHandler?(true)
            }
        }
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {return}
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: {$0.name == "code"})?.value else {return}
        print("code:\(code)")
        webView.isHidden = true
        
        AuthManager.shared.exchangeCodeForToken(code: code) {[weak self] sucess in
            
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(sucess)
            }
        }
    }
     
    }



