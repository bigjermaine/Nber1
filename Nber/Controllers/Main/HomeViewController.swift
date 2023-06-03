//
//  HomeViewController.swift
//  Nber
//
//  Created by Apple on 02/06/2023.
//

import UIKit
import MapKit
import CoreLocation
import FloatingPanel



class HomeViewController: UIViewController,SearchViewControllerDelegate,MKMapViewDelegate,PriceViewControllerDelegate {
 
    
   
    var directionArray :[MKDirections] = []
    
  
    
    static let shared = HomeViewController()
    
    var mapView = MKMapView()
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private var albumNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 40,weight: .semibold)
        label.backgroundColor = .black
        label.numberOfLines = 0
        return label
    }()
    

    let searchVC =  Nber.SearchViewController()
    let panel = FloatingPanelController()
    
    let priceVC =  Nber.PriceViewController()
    let panel2 = FloatingPanelController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Configure map view
        
        navBar()
        title = "Nber"
        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
        view.addSubview( albumNameLabel)
        mapView.delegate = self
      
         searchVC.delegate = self
        priceVC.delegate = self
        panel2.set(contentViewController:priceVC)
        panel2.addPanel(toParent: self)
        panel2.move(to: .tip, animated: true)
    
        panel.set(contentViewController: searchVC)
        panel.addPanel(toParent: self)
        
           
        APICaller.shared.getNewRelaseses { result in
            switch result {
                
            case .success(let name):
                print(name)
            case .failure(_):
                break
            }
        }
        
        LocationManager.shared.getUserLocation { location in
            DispatchQueue.main.async { [weak self ] in
                
                guard let annotations = self?.mapView.annotations else {return}
                self?.mapView.removeAnnotations(annotations)
                let pin  = MKPointAnnotation()
                pin.coordinate = location.coordinate
                self?.mapView.addAnnotation(pin)
                
                self?.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8)), animated: true)
            }
            LocationManager.shared.resolveLocationName(with:location) {[weak self] name in
                if let name = name {
                    self?.title = " your Location: \(name)"
                }
            }
        }
      
      
    }
    
    private  func navBar() {
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(navigateToSigningScreen))

         navigationItem.rightBarButtonItem =  profileButton 
    }
    
    @objc func navigateToSigningScreen() {
        let vc =  ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
        albumCoverImageView.frame = CGRect(x: view.bounds.width/2, y: view.bounds.height/2, width: 40, height: 40)
        albumNameLabel.frame = CGRect(x: view.bounds.width/8, y: view.bounds.height - 100, width:  view.bounds.width - 100, height: 40 )
    }
    
     
  public  func resetMapView(withNew direction: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionArray.append(direction)
        let _ = directionArray.map({$0.cancel()})
      
        
    }
    
    func SearchViewController(_ vc: SearchViewController, didselectionwith coordinates: CLLocationCoordinate2D?) {
        if  LocationManager.shared.manager.authorizationStatus == .denied {
            alertUserLoginError()
           
        }else {
            guard let coordinates = coordinates else {return}
            
            panel.move(to: .tip, animated: true)
            panel2.move(to: .half, animated: true)
            mapView.removeAnnotations(mapView.annotations)
            let pin  = MKPointAnnotation()
            pin.coordinate = coordinates
            mapView.addAnnotation(pin)
            
            mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8)), animated: true)
            
            mapView.removeOverlays(mapView.overlays)
            LocationManager.shared.getUserRoute { [weak self] response in
                
                for route in response.routes {
                    self?.mapView.addOverlay(route.polyline)
                    self?.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                    print(route.distance)
                    self?.priceVC.routeDistance = route.distance
                    
                   
                }
            
                
            }
          
        }
      
    }
    
    func PriceViewController(_ vc: PriceViewController, didselectionwith bool: Bool) {
        if bool {
            panel.move(to: .half, animated: true)
            panel2.move(to: .tip, animated: true)
            alertRide()
         
        }else {
            CancelRide()
            panel.move(to: .half, animated: true)
            panel2.move(to: .tip, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polylineOverlay = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(overlay: polylineOverlay)
            renderer.strokeColor = .blue
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    private  func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops", message: "Please allow Location,you cant continue without that", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dimiss", style: .cancel))
        alert.addAction(UIAlertAction(title: "Allow Location", style: .destructive,handler: { _ in
            LocationManager.shared.manager.requestWhenInUseAuthorization()
        }))
        present(alert, animated: true)
    }
    private  func alertRide() {
        let alert = UIAlertController(title: "Driver", message: "Driver is on his way relax and wait patiently", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .cancel))
        alert.addAction(UIAlertAction(title: "Cancel Ride", style: .destructive,handler: { _ in
            HapticManager.shared.vibrate(for: .error)
        }))
        present(alert, animated: true)
    }
    
    private  func CancelRide() {
        let alert = UIAlertController(title: "Woops", message: "Ride Cancelled", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dimiss", style: .cancel))
        present(alert, animated: true)
    }
}
    
 
