//
//  MapViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/06/20.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

  private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        searchBar.delegate = self
        mapView.delegate = self
        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(searchBar)
        view.addSubview(mapView)
        backButton.addTarget(self, action:#selector(back), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.frame = CGRect(x: view.safeAreaInsets.left, y: view.safeAreaInsets.bottom+20, width: 30, height: 20)
        searchBar.frame = CGRect(x: view.safeAreaInsets.left, y: backButton.bottom+10, width: view.frame.width, height: 50)
        mapView.frame = CGRect(x: 0, y: searchBar.bottom, width: view.frame.width, height: view.frame.height-searchBar.frame.height)
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    private let backButton:UIButton = {
        UIButton.backButton()
    }()
    
    private let searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
        
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation!.title != "My Location"{
        let eventDetailViewController = self.presentingViewController as! EventDetailViewController
        eventDetailViewController.eventPlace = view.annotation!.title!
        dismiss(animated: true, completion: nil)
        }else{
            print("警告を出す")
        }
    }
    
    @objc func back(){
        let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false)
    }
}
extension MapViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBar.text
    
        let localSearch:MKLocalSearch = MKLocalSearch(request: request)
        localSearch.start(completionHandler: ({(result, error)in
            if result == nil {
                return
            }
            for placemark in (result!.mapItems){
                if(error == nil){
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(placemark.placemark.coordinate.latitude, placemark.placemark.coordinate.longitude)
                    annotation.title = placemark.placemark.name ?? ""
                    
                    annotation.subtitle = placemark.placemark.title
                    
                    self.mapView.addAnnotation(annotation)
                } else{
                    print(error!)
                }
            }
        }))
    }
}
