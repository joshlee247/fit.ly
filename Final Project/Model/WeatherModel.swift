import Foundation

class WeatherModel {
    static let shared = WeatherModel()
    var weather: WeatherReport!
    
    let ACCESS_KEY = "7fa41bdb5094df39c120523c3864c7fa"
    let BASE_URL = "https://api.openweathermap.org/"
    
    func getWeather(onSuccess: @escaping (WeatherReport) -> Void) {
        // create get request to OpenWeather API
        print("called getWeather")
        if let url = URL(string: "\(BASE_URL)data/2.5/weather?q=Los%20Angeles&units=imperial&appid=\(ACCESS_KEY)") {
            let urlRequest = URLRequest(url: url)
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    do {
                        print("Getting weather...")
                        let res = try JSONDecoder().decode(WeatherResponse.self, from: data)
                        self.weather = WeatherReport(temp: res.main.temp, icon: res.weather)
                        // return weater data to @escaping
                        onSuccess(self.weather)
                    } catch let error {
                        print(error)
                        // Handle decoding error...
                        exit(1)
                    }
                }
            }.resume()
        }
    }
}
