//
//  ViewController.swift
//  nabelova_1PW7
//
//  Created by Наталья Белова on 25.01.2022.
//

import UIKit
import CoreLocation
import MapKit

final class NavViewController: UIViewController, MKMapViewDelegate {
    
    var coordinates: [CLLocationCoordinate2D] = []
    
    
    private let startLocation: UITextField = {
        let control = UITextField()
        control.backgroundColor = UIColor.white
        control.textColor = UIColor.black
        control.placeholder = "From"
        control.layer.cornerRadius = 2
        control.clipsToBounds = false
        control.font = UIFont.systemFont(ofSize: 15)
        control.borderStyle = UITextField.BorderStyle.roundedRect
        control.autocorrectionType = UITextAutocorrectionType.yes
        control.keyboardType = UIKeyboardType.default
        control.returnKeyType = UIReturnKeyType.done
        control.clearButtonMode =
        UITextField.ViewMode.whileEditing
        control.contentVerticalAlignment =
        UIControl.ContentVerticalAlignment.center
        return control
    }()
    
    private let endLocation: UITextField = {
        let control = UITextField()
        control.backgroundColor = UIColor.white
        control.textColor = UIColor.black
        control.placeholder = "To"
        control.layer.cornerRadius = 2
        control.clipsToBounds = false
        control.font = UIFont.systemFont(ofSize: 15)
        control.borderStyle = UITextField.BorderStyle.roundedRect
        control.autocorrectionType = UITextAutocorrectionType.yes
        control.keyboardType = UIKeyboardType.default
        control.returnKeyType = UIReturnKeyType.done
        control.clearButtonMode =
        UITextField.ViewMode.whileEditing
        control.contentVerticalAlignment =
        UIControl.ContentVerticalAlignment.center
        return control
    }()
    
    private let goButton: CustomButton = {
        let button = CustomButton(with: CustomButtonViewModel(title: "Go", backgroundColor: .systemBlue, textColor: .white))
        button.widthAnchor.constraint(equalToConstant: 160.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(goButtonWasPressed), for: .touchUpInside)
        return button
    }()
    
    private let clearButton: CustomButton = {
        let button = CustomButton(with: CustomButtonViewModel(title: "Clear", backgroundColor: UIColor.lightGray, textColor: UIColor.gray))
        button.widthAnchor.constraint(equalToConstant: 160.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(clearButtonWasPressed), for: .touchUpInside)
        return button
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = NSLayoutConstraint.Axis.horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        view.spacing = 15.0
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        mapView.mapType = MKMapType.standard
        mapView.center = view.center
        view.addSubview(mapView)
        stackView.addArrangedSubview(goButton)
        stackView.addArrangedSubview(clearButton)
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -85).isActive = true
        let textStack = UIStackView()
            textStack.axis = .vertical
            view.addSubview(textStack)
            textStack.spacing = 10
            textStack.pin(to: view, [.top: 50, .left: 10, .right: 10])
            [startLocation, endLocation].forEach {
                textField in
                textField.setHeight(to: 40)
                textField.delegate = self
                textStack.addArrangedSubview(textField)
            }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                
        view.addGestureRecognizer(tap)
        mapView.delegate = self
    }
    
    @objc func dismissKeyboard() {
           view.endEditing(true)
       }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
    }
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.layer.masksToBounds = true
        mapView.layer.cornerRadius = 5;
        mapView.clipsToBounds = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
        return mapView
    }()
    
    @objc func clearButtonWasPressed(){
           startLocation.text = ""
           endLocation.text = ""
           clearButton.setTitleColor(.gray, for: .disabled)
           clearButton.backgroundColor = .lightGray
           clearButton.isEnabled = false
       }
       

    private func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> ()){
                DispatchQueue.global(qos: .background).async {
                    CLGeocoder().geocodeAddressString(address){
                        completion($0?.first?.location?.coordinate, $1)
                }
            }
            
    }

    @objc func goButtonWasPressed(){
            guard
                let first = startLocation.text,
                let second = endLocation.text,
                first != second
            else {
                return
            }
            let group = DispatchGroup()
            group.enter()
            getCoordinateFrom(address: first, completion: { [weak self] coords,_ in
                if let coords = coords{
                    self?.coordinates.append(coords)
                }
                group.leave()
            })
            
            group.enter()
            getCoordinateFrom(address: second, completion: { [weak self] coords,_ in
                if let coords = coords{
                    self?.coordinates.append(coords)
                }
                group.leave()
            })
            group.notify(queue: .main){
                DispatchQueue.main.async {
                    [weak self] in self?.buildPath()
                }
            }
            coordinates = []
            
        }
        
        private func buildPath(){
            if (coordinates.count != 2) {
                return
            }
            let sourceCoordinate = coordinates[0]
            let destinationCoordinate = coordinates[1]
            let sPlaceMark = MKPlacemark(coordinate: sourceCoordinate)
            let dPlaceMark = MKPlacemark(coordinate: destinationCoordinate)
            
            let sourceItem = MKMapItem(placemark: sPlaceMark)
            let destinationItem = MKMapItem(placemark: dPlaceMark)
            
            
            let directionRequest = MKDirections.Request();
            directionRequest.source = sourceItem
            directionRequest.destination = destinationItem
            
            directionRequest.transportType = .automobile
                    
            let directions = MKDirections(request: directionRequest)
            directions.calculate { (response, error) in
                guard let response = response else {
                    if let error = error {
                    }
                    return
                }
                let route = response.routes[0]
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
            render.strokeColor = .systemBlue
            render.lineWidth = 5
            return render
        }
}

extension NavViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           if(textField == endLocation && startLocation.hasText){
               goButtonWasPressed()
           }
           return true
       }
       
       func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
           if (textField.hasText) {
               clearButton.setTitleColor(.black, for: .normal )
               clearButton.backgroundColor = .white
               clearButton.isEnabled = true
           }
       }
}
