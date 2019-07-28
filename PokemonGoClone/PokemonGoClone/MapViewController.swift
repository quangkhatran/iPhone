//
//  MapViewController.swift
//  PokemonGoClone
//
//  Created by Quang Kha Tran on 27/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var updateCount = 0
    var pokemons: [Pokemon] = []
    
    
    @IBAction func centerTapped(_ sender: Any) {
        if let center = manager.location?.coordinate {
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setup()
        }
    }
    
    func setup(){
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        mapView.delegate = self
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            if let center = self.manager.location?.coordinate {
                var annoCoord = center
                annoCoord.latitude  += ( Double.random(in: 0...200)-100.0 )/50_000.0
                annoCoord.longitude += ( Double.random(in: 0...200)-100.0 )/50_000.0
                if let pokemon = self.pokemons.randomElement() {
                    let anno = PokeAnnotation(coord: annoCoord, pokemon: pokemon)
                    self.mapView.addAnnotation(anno)
                }
            }
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if annotation is MKUserLocation {
            annoView.image = UIImage(named: "player")
        } else {
            if let pokeAnnotation = annotation as? PokeAnnotation {
                if let imageName = pokeAnnotation.pokemon.imageName {
                    annoView.image = UIImage(named: imageName)
                }
            }
        }
        
        var frame = annoView.frame
        frame.size.height = 50.0
        frame.size.width = 50.0
        annoView.frame = frame
        
        return annoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        if view.annotation is MKUserLocation { // when we tap on the player's annotation
            
        } else { // when we tap on the pokemon's annotation
            if let center = manager.location?.coordinate {
                if let pokeCenter = view.annotation?.coordinate {
                    let region = MKCoordinateRegion(center: pokeCenter, latitudinalMeters: 200, longitudinalMeters: 200)
                    mapView.setRegion(region, animated: false)
                    if let pokeAnnotation = view.annotation as? PokeAnnotation {
                        if let pokeName = pokeAnnotation.pokemon.name {
                            if mapView.visibleMapRect.contains(MKMapPoint(center)) { // caught a pokemon
                                pokeAnnotation.pokemon.caught = true
                                let alertVC = UIAlertController(title: "Congrats!", message: "You caught a \(pokeName)", preferredStyle: .alert)
                                let pokeDexAction = UIAlertAction(title: "PokeDex", style: .default) { (action) in
                                    self.performSegue(withIdentifier: "moveToPokedex", sender: nil)
                                }
                                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                alertVC.addAction(pokeDexAction)
                                alertVC.addAction(okAction)
                                present(alertVC, animated: true, completion: nil)
                            } else { // failed to catch a pokemon
                                let alertVC = UIAlertController(title: "Oops!", message: "You were too far away from this \(pokeName) to catch it. Try moving closer!", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                alertVC.addAction(okAction)
                                present(alertVC, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            if let center = manager.location?.coordinate {
                let region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
                mapView.setRegion(region, animated: false)
            }
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setup()
        } else {
            manager.requestWhenInUseAuthorization()
        }
        
    }
}
