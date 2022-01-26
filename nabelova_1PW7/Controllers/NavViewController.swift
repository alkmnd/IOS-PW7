//
//  ViewController.swift
//  nabelova_1PW7
//
//  Created by Наталья Белова on 25.01.2022.
//

import UIKit
import CoreLocation
import MapKit

final class NavViewController: UIViewController {
    
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
        return button
    }()
    
    private let clearButton: CustomButton = {
        let button = CustomButton(with: CustomButtonViewModel(title: "Clear", backgroundColor: .systemBlue, textColor: .white))
        button.widthAnchor.constraint(equalToConstant: 160.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        button.layer.cornerRadius = 30
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
    
    private func configureUI() {
        
    }


}

extension NavViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
