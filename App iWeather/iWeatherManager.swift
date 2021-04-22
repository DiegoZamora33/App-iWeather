//
//  iWeatherManager.swift
//  App iWeather
//
//  Created by Diego Zamora on 22/04/21.
//

import Foundation

class iWeatherManager {
    private let apiURL = "https://api.openweathermap.org/data/2.5/weather?appid=43c02b88939bc65afefdef7ff3b31822&q="
    
    // MARK: - Search City
    public func searchCity(city: String) {
        let myURL = "\(apiURL)\(city)"
        
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
        if error != nil
        {
            print("Error al obtener los datos -> \(error!)")
        }
        else
        {
            if let secureRsponse = response
            {
                print("Respuesta: \(secureRsponse)")
            }
            
            if let secureData = data {
                let stringData = String(data: secureData, encoding: .utf8)
                print(stringData!)
            }
        }
    }
}
