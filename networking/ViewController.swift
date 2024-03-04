//
//  ViewController.swift



import UIKit
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate{

    // Variable Declaration
    let myLocationManager  = CLLocationManager()
    var apicalling = false
    var areYouJumpingToWaterloo = false
    var myLocation = CLLocation()
    
    // Background ImageView
    @IBOutlet var backgroundImageView: UIImageView!
    
    // Weather Image View
    @IBOutlet var weatherImageView: UIImageView!
    
    // City Name LabelView
    @IBOutlet var cityNameLabelView: UILabel!
    
    // Weather Title LabelView
    @IBOutlet var weatherTitleLabelView: UILabel!
    
    // Weather Description LabelView
    @IBOutlet var weatherDescriptionLabelView: UILabel!
    
    // weather Temperature LabelView
    @IBOutlet var weatherTempretureLabelView: UILabel!
    
    // weather Temperature Feels Like LabelView
    @IBOutlet var weatherTempretureFeesLikeLabelView: UILabel!
    
    // Weather Humidity LabelView
    @IBOutlet var weatherHumidityLabelView: UILabel!
    
    // Weather Wind LabelView
    @IBOutlet var windSpeedLabelView: UILabel!
    
    // Api Call Refresh ButtonView
    @IBOutlet var refreshApiCallButtonView: UIButton!
    
    // Junp to Waterloo ButtonView
    @IBOutlet var junpToWaterlooButtonView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // --------- Initialize Location Manager
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.requestWhenInUseAuthorization()
        myLocationManager.startUpdatingLocation()
        
        // --------- UI for Refresh Button
        refreshApiCallButtonView.layer.cornerRadius = 10
        refreshApiCallButtonView.layer.shadowColor = UIColor.white.cgColor
        refreshApiCallButtonView.layer.shadowRadius = 10
        refreshApiCallButtonView.layer.shadowOffset = CGSize(width: 0, height: 0)
        refreshApiCallButtonView.layer.shadowOpacity = 0.7
        
        
        junpToWaterlooButtonView.layer.cornerRadius = 10
        junpToWaterlooButtonView.layer.shadowColor = UIColor.white.cgColor
        junpToWaterlooButtonView.layer.shadowRadius = 10
        junpToWaterlooButtonView.layer.shadowOffset = CGSize(width: 0, height: 0)
        junpToWaterlooButtonView.layer.shadowOpacity = 0.7
        
        self.backgroundImageView.image = UIImage(named: "weather")
    }
    

    
    
    // This is my Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = locations[0]
        self.myWeatherApiCalling(myLocation.coordinate.latitude, myLocation.coordinate.longitude)
        
    }
    
    // Api Calling for selected weather location
    func myWeatherApiCalling(_ latitude : CLLocationDegrees, _ longitude : CLLocationDegrees) {
        if(apicalling == false){
            
            apicalling = true
            var urlString = ""
          
            if(areYouJumpingToWaterloo == true){
                areYouJumpingToWaterloo = false;
                urlString = "https://api.openweathermap.org/data/2.5/weather?lat=43.4936158&lon=-80.5652623&appid=ee083e447eca3842f05443803f458eb0"

            }else{
                urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=ee083e447eca3842f05443803f458eb0"
            }
//            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=ee083e447eca3842f05443803f458eb0"
//
            var myAPIRequest = URLRequest(url: URL(string: urlString)!,timeoutInterval: Double.infinity)
            
           

            myAPIRequest.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: myAPIRequest) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                do{
                    let weatherData = try
                    JSONDecoder().decode(WeatherData.self, from: data)
                    DispatchQueue.main.async {
                        self.cityNameLabelView.text = "\(weatherData.name)"
                        self.weatherDescriptionLabelView.text = "\(weatherData.weather[0].description)"
                        self.weatherTitleLabelView.text = "\(weatherData.weather[0].main)"
                        self.weatherTempretureLabelView.text = "\(String(format: "%.1f", weatherData.main.temp - 273.15)) °C"
                        self.weatherTempretureFeesLikeLabelView.text = "Feels Like : \(String(format: "%.1f", weatherData.main.feelsLike - 273.15)) °C"
                        self.weatherHumidityLabelView.text = "\(weatherData.main.humidity) %"
                        self.windSpeedLabelView.text = "\(String(format: "%.2f", weatherData.wind.speed * 3.6)) km/h"
                        self.weatherImageView.load(urlString: "https://openweathermap.org/img/wn/\(weatherData.weather[0].icon).png")
                        if("\(weatherData.weather[0].main)" == "Clouds"){
                            self.backgroundImageView.image = UIImage(named: "cloud")
                        }else if("\(weatherData.weather[0].main)" == "Atmosphere"){
                            self.backgroundImageView.image = UIImage(named: "atmosphere")
                        }else if("\(weatherData.weather[0].main)" == "Snow"){
                            self.backgroundImageView.image = UIImage(named: "snow")
                        }else if("\(weatherData.weather[0].main)" == "Clear"){
                            self.backgroundImageView.image = UIImage(named: "clear")
                        }else if("\(weatherData.weather[0].main)" == "Rain"){
                            self.backgroundImageView.image = UIImage(named: "rain")
                        }else if("\(weatherData.weather[0].main)" == "Thunderstorm"){
                            self.backgroundImageView.image = UIImage(named: "thunderstrom")
                        }else if("\(weatherData.weather[0].main)" == "Drizzle"){
                            self.backgroundImageView.image = UIImage(named: "drizzel")
                        }else {
                            self.backgroundImageView.image = UIImage(named: "weather")
                        }
                    }
                }catch{



                    self.cityNameLabelView.text = "Error"
                    self.weatherDescriptionLabelView.text = "Error"
                    self.weatherTitleLabelView.text = "Error"
                    self.weatherTempretureLabelView.text = "Error"
                    self.weatherTempretureFeesLikeLabelView.text = "Error"
                    self.weatherHumidityLabelView.text = "Error"
                    self.windSpeedLabelView.text = "Error"

                    print(">>>>>>> There is problem with API data, Please Run after some time")
                    
                    
                    

                    print(error.localizedDescription)
                }
                print(String(data: data, encoding: .utf8)!)
            }
            task.resume()
//            myLocationManager.stopUpdatingLocation()
        }
    }
    
    // Refresh my Api data
    @IBAction func refreshMyApi(_ sender: Any) {
        // Reset All Data
        apicalling = false
        self.cityNameLabelView.text = "Loading..."
        self.weatherDescriptionLabelView.text = "Loading..."
        self.weatherTitleLabelView.text = "Loading..."
        self.weatherTempretureLabelView.text = "Loading..."
        self.weatherTempretureFeesLikeLabelView.text = "Loading..."
        self.weatherHumidityLabelView.text = "Loading..."
        self.windSpeedLabelView.text = "Loading..."
        self.weatherImageView.load(urlString: "")
        self.backgroundImageView.image = UIImage(named: "weather")
        self.myWeatherApiCalling(myLocation.coordinate.latitude, myLocation.coordinate.longitude)
    }
    
    
    @IBAction func jumpToWaterloo(_ sender: Any) {
        apicalling = false
        areYouJumpingToWaterloo = true
        self.cityNameLabelView.text = "Loading..."
        self.weatherDescriptionLabelView.text = "Loading..."
        self.weatherTitleLabelView.text = "Loading..."
        self.weatherTempretureLabelView.text = "Loading..."
        self.weatherTempretureFeesLikeLabelView.text = "Loading..."
        self.weatherHumidityLabelView.text = "Loading..."
        self.windSpeedLabelView.text = "Loading..."
        self.weatherImageView.load(urlString: "")
        self.backgroundImageView.image = UIImage(named: "weather")
        self.myWeatherApiCalling(myLocation.coordinate.latitude, myLocation.coordinate.longitude)
 
    }
    
}
