import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}
