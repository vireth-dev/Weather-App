import Foundation

class WeatherService {
    private let apiKey = "YOUR_API_KEY" // ใส่ API Key ของ OpenWeatherMap
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(for city: String, completion: @escaping (WeatherResponse?) -> Void) {
        guard let urlString = "\(baseURL)?q=\(city)&appid=\(apiKey)&units=metric"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            let decoder = JSONDecoder()
            if let weatherData = try? decoder.decode(WeatherResponse.self, from: data) {
                completion(weatherData)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
