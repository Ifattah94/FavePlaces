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
           return mv
       }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()

    
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
