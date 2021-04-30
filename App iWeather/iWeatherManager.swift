//
//  iWeatherManager.swift
//  App iWeather
//
//  Created by Diego Zamora on 22/04/21.
//

import Foundation
import CoreLocation

protocol iWeatherDelegate {
    func getWeather(weatherData: iWeatherData?, httpResponse: URLResponse?, error: Error?)
}

class iWeatherManager {
    private let apiURL = "https://api.openweathermap.org/data/2.5/weather?appid=6870e1278a35d6d2aaacb45e5a6ace11&units=metric&lang=es&"
    
    /// Delegate
    var delegate: iWeatherDelegate?
    
    
    // MARK: - Search Name City
    public func searchCity(city: String) {
        let myURL = "\(apiURL)q=\(city)"
        
        executeRequest(url: myURL)
    }
    
    // MARK: - Search Coordenadas City
    public func searchCity(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let myURL = "\(apiURL)lat=\(lat)&lon=\(lon)"
        print(myURL)
        executeRequest(url: myURL)
    }
    
    // MARK: - Execute Request
    private func executeRequest(url: String)
    {
        /// Crear OBJ URL
        if let objURL = URL(string: url)
        {
            /// Crear SESSION
            let objSESSION = URLSession(configuration: .default)
            
            /// Asignar una Tarea a la SESSION
            let objTASK = objSESSION.dataTask(with: objURL, completionHandler: response(data:response:error:))
            
            /// Iniciar la Tarea
            objTASK.resume()
            
        }
        
    }
    
    // MARK: - Response
    private func response(data: Data?, response: URLResponse?, error: Error?)
    {
        /// Send Data pipe Delegate
        delegate?.getWeather(weatherData: dataToObject(data: data), httpResponse: response, error: error)
    }
    
    // MARK: - Data to Object
    private func dataToObject(data: Data?) -> iWeatherData?
    {
        /// Crear un Decadificador JSON
        let decodificador = JSONDecoder()
        
        do {
            let decodeData = try decodificador.decode(iWeatherData.self, from: data!)
            
            /// Mi Objeto con los datos
            return decodeData
            
        } catch {
            return nil
        }
    }
}
