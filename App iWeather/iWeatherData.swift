//
//  iWeatherData.swift
//  App iWeather
//
//  Created by Diego Zamora on 27/04/21.
//

import Foundation

class iWeatherData: Decodable {
    let name: String
    let main: Main
    let wind: Wind
    let weather: [Weather]
    
    
    struct Weather: Decodable {
        let main: String
        let description: String
        let icon: String
    }
    
    struct Wind: Decodable {
        let speed: Double
    }
    
    struct Main: Decodable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }
}
