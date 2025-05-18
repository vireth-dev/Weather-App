import Foundation
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var city = "Bangkok"
    @Published var temperature: String = "--"
    @Published var description: String = ""
    @Published var icon: String = "cloud"
    
    private let weatherService = WeatherService()
    
    func fetchWeather() {
        weatherService.fetchWeather(for: city) { [weak self] data in
            DispatchQueue.main.async {
                if let data = data {
                    self?.temperature = "\(Int(data.main.temp))°C"
                    self?.description = data.weather.first?.description.capitalized ?? ""
                    self?.icon = self?.mapIcon(data.weather.first?.icon ?? "") ?? "cloud"
                }
            }
        }
    }
    
    private func mapIcon(_ code: String) -> String {
        switch code {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d", "02n": return "cloud.sun.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d", "10n": return "cloud.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "cloud.snow.fill"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
}
