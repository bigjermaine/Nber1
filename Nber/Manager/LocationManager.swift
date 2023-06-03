//
//  LocationManager.swift
//  Nber
//
//  Created by Apple on 02/06/2023.
//

import Foundation
import CoreLocation
import MapKit

struct Location {
    let title:String
    
    let coordinates:CLLocationCoordinate2D?
}

class LocationManager:NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    var startLocation: CLLocation!
    
    var endlocation :CLLocation!
    
    let manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    
    
    public func findLocations(with query:String,completion: @escaping (([Location]) -> Void)) {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(query) { places, error in
            guard let places = places , error == nil else {
                completion([])
                return}
            
            let models:[Location] = places.compactMap { place in
                var name = ""
                if let locationName = place.name {
                    name += locationName
                    
                }
                if let adminRegion = place.thoroughfare {
                    name += ", \(adminRegion)"
                    
                }
                if let locationName = place.subThoroughfare {
                    name += ", \(locationName)"
                    
                }
                
                if let country = place.country {
                    name += ", \(country)"
                    
                }
                 
               // print(place)
               // guard place.location != nil else {return}
                self.endlocation = place.location
                let result = Location(title: name, coordinates: place.location?.coordinate)
                print(result)
                return result
               
            }
          completion(models)
        }
    }
    
    
    public func getUserLocation(completion:@escaping ((CLLocation) ->Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        completion?(location)
        startLocation = location
        manager.stopUpdatingLocation()
    }
    
    public func resolveLocationName(with location:CLLocation,completion: @escaping(String?)-> Void) {
       
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            guard  error == nil,let placemark = placemarks?.first else {
                completion(nil)
                return}
            
            var name = ""
            if let locationName = placemark.name {
                name += locationName
                
            }
            if let adminRegion = placemark.thoroughfare {
                name += ", \(adminRegion)"
                
            }
            if let locationName = placemark.subThoroughfare {
                name += ", \(locationName)"
                
            }
            
            if let country = placemark.country {
                name += ", \(country)"
                
            }
            completion(name)
        }
    }
    
    
   public func createDirectionRequest() -> MKDirections.Request {
      
        let startingLocation = MKPlacemark(coordinate: startLocation.coordinate)
        let endLocation = MKPlacemark(coordinate: endlocation.coordinate)
        
       
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark:  startingLocation)
        request.destination = MKMapItem(placemark: endLocation)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        return request
    }
    
    public func getUserRoute(completion:@escaping ((MKDirections.Response) ->Void)) {
           let request = createDirectionRequest()
           let directions = MKDirections(request: request)
        
        //Note:resetting mapView
        
         HomeViewController.shared.resetMapView(withNew: directions)
        
         directions.calculate { responses, error in
            guard let response = responses,error == nil else {return
            
            }
           completion(response)
        }
    }
    
    
}
