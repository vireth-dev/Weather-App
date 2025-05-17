import Foundation

// ========== ENUM ==========
enum WeatherType: String, Codable {
    case sunny, cloudy, rainy, snowy, unknown
}

// ========== MODEL ==========
struct Weather: Codable {
    let city: String
    let temperature: Double
    let condition: WeatherType
    let updatedAt: Date
}

// ========== ERROR HANDLING ==========
enum WeatherError: Error, CustomStringConvertible {
    case invalidURL
    case requestFailed
    case decodingFailed

    var description: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .requestFailed: return "Request failed"
        case .decodingFailed: return "Failed to decode response"
        }
    }
}

// ========== PROTOCOL ==========
protocol WeatherService {
    func fetchWeather(for city: String) async -> Result<Weather, WeatherError>
}

// ========== SERVICE IMPLEMENTATION ==========
class FakeWeatherAPIService: WeatherService {
    func fetchWeather(for city: String) async -> Result<Weather, WeatherError> {
        try? await Task.sleep(nanoseconds: 1_000_000_000) // simulate delay

        let dummy = Weather(
            city: city,
            temperature: Double.random(in: 15...35),
            condition: [.sunny, .cloudy, .rainy, .snowy].randomElement() ?? .unknown,
            updatedAt: Date()
        )
        return .success(dummy)
    }
}

// ========== VIEWMODEL ==========
class WeatherViewModel: ObservableObject {
    private let service: WeatherService
    @Published private(set) var weather: Weather?
    @Published private(set) var errorMessage: String?

    init(service: WeatherService) {
        self.service = service
    }

    func loadWeather(for city: String) async {
        let result = await service.fetchWeather(for: city)
        switch result {
        case .success(let weather):
            self.weather = weather
            self.errorMessage = nil
        case .failure(let error):
            self.errorMessage = error.description
        }
    }
}

// ========== EXTENSIONS ==========
extension Weather {
    var formattedTemperature: String {
        String(format: "%.1f℃", temperature)
    }

    var icon: String {
        switch condition {
        case .sunny: return "☀️"
        case .cloudy: return "☁️"
        case .rainy: return "🌧"
        case .snowy: return "❄️"
        default: return "❓"
        }
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: updatedAt)
    }
}

// ========== SIMULATION ==========
@main
struct WeatherSimulator {
    static func main() async {
        let service = FakeWeatherAPIService()
        let viewModel = WeatherViewModel(service: service)

        await viewModel.loadWeather(for: "Bangkok")

        if let weather = viewModel.weather {
            print("📍 City: \(weather.city)")
            print("🌡 Temp: \(weather.formattedTemperature)")
            print("☁️ Weather: \(weather.condition.rawValue.capitalized) \(weather.icon)")
            print("🕒 Updated: \(weather.formattedDate)")
        } else if let error = viewModel.errorMessage {
            print("❌ Error: \(error)")
        }
    }
}
