//
//  MainMapViewController.swift
//  FavoritePlaces
//
//  Created by C4Q on 11/20/19.
//  Copyright © 2019 Iram Fattah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainMapViewController: UIViewController {

    //MARK: UI Objects
       lazy var mapView: MKMapView = {
           let mv = MKMapView()
           mv.mapType = .standard
        mv.isUserInteractionEnabled = true
           return mv
       }()
    
    //MARK: Private Properties
    
    private let locationManager = CLLocationManager()
    private let initialLocation = CLLocationCoordinate2D(latitude: 40.742054, longitude: -73.769417)
    private let searchRadius: CLLocationDistance = 2000
    
    
    //MARK: Lifeycyle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        setupMapView()
        requestLocationAndAuthorizeIfNeeded()
        setupMap()
        setupLongPressGesture()

    
    }
    

    //MARK: Private Methods
    
    private func setupMap() {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
    }
    
    private func setupLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(sender:)))
        mapView.addGestureRecognizer(longPress)
    }
    
    private func requestLocationAndAuthorizeIfNeeded() {
        switch CLLocationManager.authorizationStatus()  {
        case .authorizedWhenInUse, .authorizedAlways :
            locationManager.requestLocation()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    private func zoomIntoUserLocation() {
        if let userLocation = locationManager.location?.coordinate {
            let coordinateRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: searchRadius, longitudinalMeters: searchRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    private func zoomIntoInitialLocation() {
        let initialRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: searchRadius, longitudinalMeters: searchRadius)
        mapView.setRegion(initialRegion, animated: true)
    }
    
    
    
    private func showAlertForAddingNewPlace(location: CLLocationCoordinate2D) {
        let alertController = UIAlertController(title: "New Place", message: "Enter Info for New Place", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let title = alertController.textFields?[0].text else {return}
            guard let user = FirebaseAuthService.manager.currentUser else {
                print("No logged in user")
                return
            }
            let lat = Double(location.latitude)
            let long = Double(location.longitude)
            let newPlace = Place(title: title, creatorID: user.uid, lat: lat, long: long)
            
            //TO DO add new place to firebase
            FireStoreService.manager.createPlace(place: newPlace) { [weak self] (result) in
                switch result {
                case .success:
                    self?.addAnnotation(location: location, title: title)
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    private func addAnnotation(location: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = title
        self.mapView.addAnnotation(annotation)
    }
    
    
    
    
    
    //MARK: objc methods
    
    @objc func handleLongTap(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            //TO DO enter into Place
            showAlertForAddingNewPlace(location: locationOnMap)
        }
    }
    
    
    
    //MARK: Constraint Methods
       
       private func setupMapView() {
           view.addSubview(mapView)
           mapView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
              mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
              mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
               mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
               mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
       }
    
    
}
extension MainMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("New locations \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            self.zoomIntoUserLocation()
        case .denied:
            print("denied")
            self.zoomIntoInitialLocation()
        default:
            break
        }
    }
    
}

extension MainMapViewController: MKMapViewDelegate {
    
}
