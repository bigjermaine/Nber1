//
//  WelcomeViewController.swift
//  Nber
//
//  Created by Apple on 02/06/2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType  = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
         return field
    }()

    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType  = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.translatesAutoresizingMaskIntoConstraints = false
         return field
    }()
    
    private let loginButton:UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .purple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        
       return button
    }()
    
   
    
    private let signInButton:UIButton = {
        let button =  UIButton()
        button.backgroundColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign In With Uber", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        title = "SignIn"
       
      
        view.addSubview(signInButton)
      
        view.addSubview(passwordField)
        view.addSubview(emailField)
        view.addSubview(loginButton)
        configure()
        signInButton.addTarget(self, action: #selector(didTapDSignin), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        navBar()
       
    }
    
    
    
    //NavigationBar ConfigurATION
    private  func navBar() {
    let signUpButton = UIBarButtonItem(image: UIImage(systemName: "person.badge.plus"), style: .plain, target: self, action: #selector(navigateToSigningScreen))

         navigationItem.rightBarButtonItem = signUpButton
    }
    
    
    
    
   
    
  private  func configure() {
     
        NSLayoutConstraint.activate([
            signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Set emailField constraints
        NSLayoutConstraint.activate([
            emailField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Set passwordField constraints
        NSLayoutConstraint.activate([
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20), // Adjust the constant value as needed
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordField.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Set loginButton constraints
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo:  passwordField.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 100),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
          ])
    }
    
    @objc func didTapDSignin() {
        let vc = AuthViewController()
        vc.completionHandler = {[weak self] sucess in
            self?.handleSignin(sucess:sucess)
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    private func handleSignin(sucess:Bool){
        guard sucess else {
            let alert = UIAlertController(title: "oops", message: "something went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dimiss", style: .cancel))
            present(alert, animated: true)
            return}
        let navc = UINavigationController(rootViewController:  HomeViewController())
         navc.modalPresentationStyle = .fullScreen
         present( navc, animated: false)
    }
    
    @objc func navigateToSigningScreen() {
        let vc = SignupViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
   
    

    @objc func signInButtonTapped() {
        HapticManager.shared.vibrateForSelection()
        guard  !emailField.text!.isEmpty && !passwordField.text!.isEmpty && passwordField.text!.count >= 6  else {
            alertUserLoginError()
            return
        }
        AuthManager.shared.signin(email: emailField.text ?? "error", password: passwordField.text ?? "error") { [weak self] check in
            if !check {
                self?.alertUserLoginError()
            }else {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
               
               let navc = UINavigationController(rootViewController:  HomeViewController())
                navc.modalPresentationStyle = .fullScreen
                self?.present( navc, animated: false)
            }
        }
        
    }
    
  
    
    private  func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to login in", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dimiss", style: .cancel))
        present(alert, animated: true)
    }
    
}
