//
//  ViewController.swift
//  App iWeather
//
//  Created by Diego Zamora on 20/04/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlet Conexiones y Variables Globales
    @IBOutlet weak var inputCity: UITextField!
    @IBOutlet weak var txtCiudad: UILabel!
    @IBOutlet weak var iconWeather: UIImageView!
    @IBOutlet weak var tempCity: UILabel!
    
    var isTouch = false
    var myWeather = iWeatherManager()
    
    
    // MARK: - Action Conexiones
    
    /// Search Ciudad
    @IBAction func searchCity(_ sender: UIButton) {
        isTouch = true
        inputCity.endEditing(true)
        
        if !inputCity.isEditing
        {
            if inputCity.text! != ""
            {
                /// Cambios Visuales
                txtCiudad.text = inputCity.text
                
                
                /// Relizar Consulta
                realizarConsulta(city: inputCity.text!)
                
                
                /// Clear Input
                inputCity.text = ""
            }
            else
            {
                inputCity.placeholder = "Escribe una Ciudad"
            }
        }
 
    }
    
    /// Boton GPS
    @IBAction func locationBtn(_ sender: UIButton) {
        
    }
    
    // MARK: - Mis Funciones
    /// * FUNCION PARA OCULTAR TECLADO *
    @objc func tapGestureHandler() {
        isTouch = false
        inputCity.endEditing(true)
      }
    
    /// * FUNCION PARA REALIZAR CONSULTA *
    func realizarConsulta(city: String)
    {
        myWeather.searchCity(city: city)
    }
    
    
    
    // MARK: - Overrides y Protocolos Func
    
    /// Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /// Para poder Ocultar el teclado
        let tapGesture = UITapGestureRecognizer(target: self, action:     #selector(tapGestureHandler))
                view.addGestureRecognizer(tapGesture)
        
        /// Delegate Text Field
        inputCity.delegate = self
    }
    
    /// Ir, teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isTouch = true
        inputCity.endEditing(true)
        return true
    }
    
    
    /// Should End Editing
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if inputCity.text! != ""
        {
            return true
        }
        else
        {
            inputCity.placeholder = "Escribe una Ciudad"
            
            if isTouch == false
            {
                return true
            }
            else
            {
                return false
            }
        }
    }
    
    /// End Editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isTouch == true
        {
            /// Cambios Visuales
            txtCiudad.text = inputCity.text
            
            
            /// Relizar Consulta
            realizarConsulta(city: inputCity.text!)
            
            
            /// Clear Input
            inputCity.text = ""
        }
       
    }
    
}

