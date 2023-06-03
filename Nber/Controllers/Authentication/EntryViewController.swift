//
//  EntryViewController.swift
//  Nber
//
//  Created by Apple on 03/06/2023.
//
import UIKit

class EntryViewController: UIViewController {

    
    private let EntryViewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image =  UIImage(named: "front")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var EntryViewLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 20,weight: .semibold)
        label.textColor = .white
        label.text = "Have A Safe Trip With Us"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let EntryButton:UIButton = {
        let button =  UIButton()
        button.backgroundColor = .black
        button.setTitle("Click here", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(EntryButton)
        view.addSubview(EntryViewLabel)
        view.addSubview(EntryViewImageView)
        configure()
        EntryButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    func configure() {
        //    EntryButton constraints
        NSLayoutConstraint.activate([
            EntryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            EntryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            EntryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            EntryButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        //   EntryViewImageView constraints
        NSLayoutConstraint.activate([
            EntryViewImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            EntryViewImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
            EntryViewImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
            EntryViewImageView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        //     EntryViewLabel constraints
        
        NSLayoutConstraint.activate([
            EntryViewLabel.bottomAnchor.constraint(equalTo: EntryViewImageView.topAnchor, constant: -50),
            EntryViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
            EntryViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
            EntryViewLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        
       
    }
   
    @objc func signInButtonTapped() {
        HapticManager.shared.vibrateForSelection()
        HapticManager.shared.vibrateForSelection()
        let vc =  WelcomeViewController()
        let Navc = UINavigationController(rootViewController: vc)
        Navc.modalPresentationStyle = .fullScreen
        self.present(Navc, animated: false)
    }
}




