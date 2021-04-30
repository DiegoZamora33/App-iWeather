//
//  ViewController.swift
//  App iWeather
//
//  Created by Diego Zamora on 20/04/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, iWeatherDelegate, CLLocationManagerDelegate {
   
    // MARK: - Outlet Conexiones y Variables Globales
    @IBOutlet weak var inputCity: UITextField!
    @IBOutlet weak var txtCiudad: UILabel!
    @IBOutlet weak var iconWeather: UIImageView!
    @IBOutlet weak var tempCity: UILabel!
    @IBOutlet weak var txtClima: UILabel!
    @IBOutlet weak var sensacionTermica: UILabel!
    @IBOutlet weak var minima: UILabel!
    @IBOutlet weak var maxima: UILabel!
    @IBOutlet weak var presion: UILabel!
    @IBOutlet weak var humedad: UILabel!
    @IBOutlet weak var imageClima: UIImageView!
    
    var isTouch = false
    var coreLocation = CLLocationManager()
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
                txtCiudad.text = "Buscando..."
                tempCity.text = " "
                
                txtClima.text = "..."
                
                sensacionTermica.text = " "
                
                minima.text = " "
                
                maxima.text = " "
                
                presion.text = " "
                
                humedad.text = " "
                
                
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
        coreLocation.startUpdatingLocation()
        
        //coreLocation.requestWhenInUseAuthorization()
        //coreLocation.requestLocation()
        
        /// Cambios Visuales
        txtCiudad.text = "Buscando..."
        tempCity.text = " "
        
        txtClima.text = "..."
        
        sensacionTermica.text = " "
        
        minima.text = " "
        
        maxima.text = " "
        
        presion.text = " "
        
        humedad.text = " "
        
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
    
    
    
    // MARK: - Cargar Imagen desde API
    func cargarImagen(urlString: String) {

            //1.- Obtener los datos

            guard let url = URL(string: urlString) else {

                return

            }

            let tareaObtenerDatos = URLSession.shared.dataTask(with: url) { (datos, _, error) in

                guard let datosSeguros = datos, error == nil else {

                    return

                }

                DispatchQueue.main.async {

                    //2.- Convertir los datos en imagen

                    let imagen = UIImage(data: datosSeguros)

                    //3.- Asignar la imagen a la imagen previamente creada

                    self.imageClima.image = imagen

                }

            }

            tareaObtenerDatos.resume()

        }
    
    
    
    
    
    // MARK: - Overrides y Protocolos Func
    
    /// Mi Protocolo iWeather
    func getWeather(weatherData: iWeatherData?, httpResponse: URLResponse?, error: Error?) {
        
        /// Esperamos a la Tarea Asincrona
        DispatchQueue.main.async {
            if(weatherData != nil)
            {
                print("City: \(String(describing: weatherData!.name))")
                
                /// Pintamos mis datos
                self.txtCiudad.text = weatherData!.name
                
                self.tempCity.text = "\(String(format: "%0.0f", weatherData!.main.temp)) °C"
                
                self.txtClima.text = weatherData!.weather[0].description.capitalized
                
                self.sensacionTermica.text = "\(String(format: "%0.1f", weatherData!.main.feels_like)) °C"
                
                self.minima.text = "\(String(format: "%0.1f", weatherData!.main.temp_min)) °C"
                
                self.maxima.text = "\(String(format: "%0.1f", weatherData!.main.temp_max)) °C"
                
                self.presion.text = "\(String(weatherData!.main.pressure)) hPa"
                
                self.humedad.text = "\(String(weatherData!.main.humidity)) %"
                
                let urlImage = "https://openweathermap.org/img/wn/\(String(weatherData!.weather[0].icon))@4x.png"
                
                self.cargarImagen(urlString: urlImage)
                
                self.imageClima.contentMode = UIView.ContentMode.scaleAspectFill
                self.imageClima.sizeToFit()
            }
            else
            {
                /// Alert para notificar algun error
                var miError: String
                var title: String
                
                if(error != nil)
                {
                    print("City: \(String(describing: error!.localizedDescription))")
                    
                    title = "Fatal Error"
                    miError = error!.localizedDescription
                }
                else
                {
                    title = "Error"
                    miError = "Ciudad no Encontrada"
                }
                
                
                let alert = UIAlertController(title: title, message: miError, preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
                
                /// Obtener ciudad Actual GPS
                self.coreLocation.startUpdatingLocation()
                
            }
            
            if(httpResponse != nil)
            {
                print("Response: \(httpResponse!)")
            }
            
            
        }
    }
    
    /// Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /// Delegate CoreLocation
        coreLocation.delegate = self
        coreLocation.requestWhenInUseAuthorization()
        coreLocation.requestLocation()
        
        
        /// Para poder Ocultar el teclado
        let tapGesture = UITapGestureRecognizer(target: self, action:     #selector(tapGestureHandler))
                view.addGestureRecognizer(tapGesture)
        
        
        /// Delegate iWeatherManager
        myWeather.delegate = self
        
        /// Delegate Text Field
        inputCity.delegate = self
        
        /// Cambios Visuales
        txtCiudad.text = "Buscando..."
        tempCity.text = " "
        
        txtClima.text = "..."
        
        sensacionTermica.text = " "
        
        minima.text = " "
        
        maxima.text = " "
        
        presion.text = " "
        
        humedad.text = " "
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
            txtCiudad.text = "Buscando..."
            tempCity.text = " "
            
            txtClima.text = "..."
            
            sensacionTermica.text = " "
            
            minima.text = " "
            
            maxima.text = " "
            
            presion.text = " "
            
            humedad.text = " "
            
            
            /// Relizar Consulta
            realizarConsulta(city: inputCity.text!)
            
            
            /// Clear Input
            inputCity.text = ""
        }
       
    }
    
    
    //MARK: - Metodos de Core Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordenadas = locations.last {
            coreLocation.stopUpdatingLocation()
            
            let latitud = coordenadas.coordinate.latitude
            let longitud = coordenadas.coordinate.longitude
            
            print("Lat: \(latitud)  :  \(longitud)")
            
            myWeather.searchCity(lat: latitud, lon: longitud)
        }
    }
    
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error al pedir Coordenadas")
    }
}

