//
//  SearchViewController.swift
//  Nber
//
//  Created by Apple on 02/06/2023.
//

import UIKit
import CoreLocation


protocol SearchViewControllerDelegate:AnyObject {
    func SearchViewController(_ vc:SearchViewController,didselectionwith coordinates:CLLocationCoordinate2D?)
   
}

class SearchViewController: UIViewController,UITextFieldDelegate {
    
    
    weak var delegate:SearchViewControllerDelegate?
    private var  addressLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 20,weight: .semibold)
        label.text = "where to"
        label.numberOfLines = 0
        return label
    }()
    
    private let field:UITextField = {
       let field = UITextField()
        field.placeholder = "Enter Destination"
        field.layer.cornerRadius = 9
        field.backgroundColor = .tertiarySystemFill
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        field.leftViewMode = .always
        return field
    }()
    
    private let tableView:UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .secondarySystemBackground
        return table
    }()
    var locations = [Location]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(addressLabel)
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(field)
        tableView.delegate = self
        tableView.dataSource = self
        field.delegate = self 
    }
    override func viewDidLayoutSubviews() {
        addressLabel.sizeToFit()
        addressLabel.frame = CGRect(x: 10, y: 10, width: addressLabel.frame.size.width, height:  addressLabel.frame.size.height)
        field.frame = CGRect(x: 10, y: 20+addressLabel.frame.size.height, width: view.frame.size.width - 20, height: 50)
        tableView.frame = CGRect(x: 0, y: 10+field.bottom, width: view.frame.size.width, height: view.frame.size.height - addressLabel.height - field.height)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        field.resignFirstResponder()
        
        
        if let text = field.text, !text.isEmpty {
         LocationManager.shared.findLocations(with: text) { [weak self] locations  in
             DispatchQueue.main.async {
                 self?.locations = locations
                 self?.tableView.reloadData()
             }
            }
            
        }
        
        return true
    }
}


extension SearchViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        cell.textLabel?.text = locations[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = .secondarySystemBackground
        return cell
        
        
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coordinate = locations[indexPath.row].coordinates
        
        delegate?.SearchViewController(self, didselectionwith: coordinate)
        
        
    }
    
    
}
