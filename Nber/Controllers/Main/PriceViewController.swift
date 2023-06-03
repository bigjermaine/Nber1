//
//  PriceViewController.swift
//  Nber
//
//  Created by Apple on 03/06/2023.
//

import UIKit
import CoreLocation

protocol PriceViewControllerDelegate:AnyObject {
    func  PriceViewController(_ vc:PriceViewController,didselectionwith bool:Bool)
   
}

class PriceViewController: UIViewController {
    
    var routeDistance: CLLocationDistance? {
        didSet {
            updateDistanceLabel()
        }
    }
    
    weak var delegate:PriceViewControllerDelegate?
    
    private var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = ""
        
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    
    private var  priceLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGreen
        label.font = .systemFont(ofSize: 15,weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private var  priceLabel2: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15,weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private var  tagLabel2: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15,weight: .bold)
        label.text = "Premium"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    private var  tagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15,weight: .bold)
        label.text = "Economy"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    private let tagButton:UIButton = {
        let button = UIButton()
        button.setTitle("Order", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.isHidden = true
       return button
    }()
    
    private let tagButton2:UIButton = {
        let button = UIButton()
        button.setTitle("Order", for: .normal)
        button.backgroundColor =  .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.isHidden = true
       return button
    }()
    
    
    private let CancelButton:UIButton = {
        let button = UIButton()
        button.setTitle("Cancel rides", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.isHidden = true
       return button
    }()
    
    private let tagLabelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image =  UIImage(named: "uber")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    private let tagLabel2ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image =  UIImage(named: "uber3")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.addSubview(tagLabelImageView)
        view.addSubview(distanceLabel)
        view.addSubview(priceLabel)
        view.addSubview(tagLabel)
        view.addSubview(tagButton)
        view.addSubview(tagLabel2ImageView)
        view.addSubview(priceLabel2)
        view.addSubview(tagLabel2)
        view.addSubview(tagButton2)
        view.addSubview(CancelButton)
      
      
        tagButton.addTarget(self, action: #selector( bookEconomy), for: .touchUpInside)
        tagButton2.addTarget(self, action: #selector(bookPremium), for: .touchUpInside)
        CancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        configure()
        updateDistanceLabel()
        
    }
    
    @objc private func bookEconomy() {
        HapticManager.shared.vibrateForSelection()
        Hide()
        delegate?.PriceViewController(self, didselectionwith: true)
        
    }
    
    @objc private func bookPremium() {
        HapticManager.shared.vibrateForSelection()
        Hide() 
        delegate?.PriceViewController(self, didselectionwith: true)
    }
    
    @objc private func cancel() {
        HapticManager.shared.vibrate(for: .error)
        Hide()
        delegate?.PriceViewController(self, didselectionwith: false)
    }
    
    func configure() {
        // Set label constraints
        NSLayoutConstraint.activate([
            distanceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tagLabelImageView.topAnchor.constraint(equalTo:  distanceLabel.topAnchor, constant: 20),
            tagLabelImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tagLabelImageView.heightAnchor.constraint(equalToConstant: 100),
            tagLabelImageView.widthAnchor.constraint(equalToConstant: 100),
            
            tagLabel.topAnchor.constraint(equalTo:  distanceLabel.topAnchor, constant: 20),
            tagLabel.leadingAnchor.constraint(equalTo:   tagLabelImageView.trailingAnchor, constant: 25),
            tagLabel.heightAnchor.constraint(equalToConstant: 50),
            tagLabel.widthAnchor.constraint(equalToConstant: 100),
            
            priceLabel.topAnchor.constraint(equalTo:   distanceLabel.topAnchor, constant: 20),
            priceLabel.leadingAnchor.constraint(equalTo:    tagLabel.trailingAnchor, constant: 20),
            priceLabel.heightAnchor.constraint(equalToConstant: 50),
            priceLabel.widthAnchor.constraint(equalToConstant: 70),
            
            tagButton.topAnchor.constraint(equalTo:  distanceLabel.topAnchor, constant: 20),
            tagButton.leadingAnchor.constraint(equalTo:    priceLabel.trailingAnchor, constant: 20),
            tagButton.heightAnchor.constraint(equalToConstant: 50),
            tagButton.widthAnchor.constraint(equalToConstant:50),
            
            
            tagLabel2ImageView.topAnchor.constraint(equalTo:     tagLabelImageView.bottomAnchor, constant: 20),
            tagLabel2ImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tagLabel2ImageView.heightAnchor.constraint(equalToConstant: 100),
            tagLabel2ImageView.widthAnchor.constraint(equalToConstant: 100),
            
            tagLabel2.topAnchor.constraint(equalTo:     tagLabelImageView.bottomAnchor, constant: 20),
            tagLabel2.leadingAnchor.constraint(equalTo:   tagLabel2ImageView.trailingAnchor, constant: 25),
            tagLabel2.heightAnchor.constraint(equalToConstant: 50),
            tagLabel2.widthAnchor.constraint(equalToConstant: 100),
            
            priceLabel2.topAnchor.constraint(equalTo:     tagLabelImageView.bottomAnchor, constant: 20),
            priceLabel2.leadingAnchor.constraint(equalTo:    tagLabel2.trailingAnchor, constant: 20),
            priceLabel2.heightAnchor.constraint(equalToConstant: 50),
            priceLabel2.widthAnchor.constraint(equalToConstant: 70),
            
            tagButton2.topAnchor.constraint(equalTo:    tagLabelImageView.bottomAnchor, constant: 20),
            tagButton2.leadingAnchor.constraint(equalTo:    priceLabel2.trailingAnchor, constant: 20),
            tagButton2.heightAnchor.constraint(equalToConstant: 50),
            tagButton2.widthAnchor.constraint(equalToConstant: 50),
            
          
            CancelButton.topAnchor.constraint(equalTo:    tagLabel2ImageView.bottomAnchor, constant: 10),
            CancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            CancelButton.heightAnchor.constraint(equalToConstant: 40),
            CancelButton.widthAnchor.constraint(equalToConstant: 150),
      
        ])
    }
    
    
    private  func updateDistanceLabel() {
     
            if let distance = routeDistance {
                DispatchQueue.main.async {[weak self] in
                    
                let distanceString = String(format: "%.2f meters", distance)
                    
                self?.distanceLabel.text = "Total Distance:\(distanceString)"
                    
                let distanceDivided = distance / 1000
                    
                let distanceDivided2 = distance / 800
                    
                let priceString = String(format: "%.2f ", distanceDivided)
                    
                let priceString2 = String(format: "%.2f ", distanceDivided2)
                    
                    self?.priceLabel.text = "$\(priceString)"
                    
                    self?.priceLabel2.text = "$\(priceString2)"
                    self?.unHide()
            }
        }
    }
    
   private func unHide() {
       CancelButton.isHidden = false
       tagButton.isHidden = false
       tagLabel.isHidden = false
       tagLabelImageView.isHidden = false
       tagButton2.isHidden = false
       tagLabel2.isHidden = false
       tagLabel2ImageView.isHidden = false
       distanceLabel.isHidden = false
       priceLabel.isHidden = false
       priceLabel2.isHidden = false
    }
    private func Hide() {
        CancelButton.isHidden = true
        distanceLabel.isHidden = true
        priceLabel.isHidden = true
        priceLabel2.isHidden = true
        tagButton.isHidden = true
        tagLabel.isHidden = true
        tagLabelImageView.isHidden = true
        tagButton2.isHidden = true
        tagLabel2.isHidden = true
        tagLabel2ImageView.isHidden = true
     }
}
