import UIKit

var greeting = "Hello, playground"

protocol FlyBehaviorProtocol {
    func fly()
}

struct FlyWithWings: FlyBehaviorProtocol {
    func fly() {
        print("I can fly with wings")
    }
}

struct FlyNoWings: FlyBehaviorProtocol {
    func fly() {
        print("I cannot fly")
    }
}

protocol QuackBehaviorProtocol {
    func quack()
}

struct Quack: QuackBehaviorProtocol {
    func quack() {
        print("Quack!! Quack!!")
    }
}

struct SilentQuack: QuackBehaviorProtocol {
    func quack() {
        print("Silence...")
    }
}

struct Squeak: QuackBehaviorProtocol {
    func quack() {
        print("Squeak!! Squeak!!")
    }
}

 protocol Duck {
     var flyBehavior: FlyBehaviorProtocol { get }
     var quackBehavior: QuackBehaviorProtocol { get }
     func performQuack()
     func performFly()
     func display()
     func swim()
}

extension Duck {
    func performQuack() {
        quackBehavior.quack()
    }
    
    func performFly() {
        flyBehavior.fly()
    }
    
    func display() {
        print("I am a generic duck")
    }
    
    func swim() {
        print("I am a generic swim")
    }
}



class MallardDuck: Duck {
    var flyBehavior: any FlyBehaviorProtocol
    var quackBehavior: any QuackBehaviorProtocol
    
    init() {
        self.flyBehavior = FlyNoWings()
        self.quackBehavior = SilentQuack()
    }
}

let duck: Duck = MallardDuck()
duck.performFly()
duck.display()
duck.swim()

/**
 Favor Composition over Inheritance.
 Has-A is better than Is-A
 Duck has a flying behavior vs Duck can fly
 Has-A lets you change behavior at runtime.
    Is-A doesn't
 */
// ------------------------------------------------------------------------ //

/** OBSERVER PATTERN **/

protocol DisplayElement {
    func display()
}

struct WeatherDataObject {
    var temperature: Float
    var humidity: Float
    var pressure: Float
}


protocol Observer<T>: Equatable, Identifiable {
    associatedtype T
    var id: Int { get }
    
    func update(_ newObject: T)
}

protocol Subject {
    associatedtype T
    func registerObserver(o: any Observer<T>)
    func removeObserver(o: any Observer<T>)
    func notifyObservers()
}

class WeatherData: Subject {
    typealias T = WeatherDataObject
    private var observers:[any Observer<WeatherDataObject>] = []
    
    func getTemperature() {
        
    }
    func getHumidity() {
        
    }
    func getPressure() {
        
    }
    func measurementsChanged() {
        
    }
}

extension WeatherData {
    func registerObserver(o: any Observer<WeatherDataObject>) {
        self.observers.append(o)
    }
    
    func removeObserver(o: any Observer<WeatherDataObject>) {
        if let index = observers.firstIndex(where: {$0.id == o.id}) {
            observers.remove(at: index)
        } else {
            print("You are not a subscriber: \(o.id). Stop Wasting my time")
        }
    }
    
    func notifyObservers() {
        self.observers.forEach { o in
            let test = WeatherDataObject(
                temperature: getRandom(),
                humidity: getRandom(),
                pressure: getRandom())
            o.update(test)
        }
    }
    
    private func getRandom() -> Float {
        return Float.random(in: 20.0...80.0)
    }
}

struct TestObserver: Observer {
    var id: Int
    func update(_ newObject: WeatherDataObject) {
        print("I have an update")
        print("\(newObject.humidity)")
    }
}

let testObserver = TestObserver(id: 3)
let weatherData = WeatherData()

class CurrentConditionsDisplay: Observer, DisplayElement {
    var id: Int = 3
    private var temperature: Float? = nil
    private var humidity: Float? = nil
    private let weatherData: WeatherData
    
    init(weatherData: WeatherData) {
        self.weatherData = weatherData
        self.weatherData.registerObserver(o: self)
    }
    
    static func == (lhs: CurrentConditionsDisplay, rhs: CurrentConditionsDisplay) -> Bool {
        lhs.id == rhs.id
    }
    
    func update(_ newObject: WeatherDataObject) {
        self.temperature = newObject.temperature
        self.humidity = newObject.humidity
        display()
    }
    
    func display() {
        print("Temperatue: \(temperature)\nHumidity: \(humidity)")
    }
}

class ForecastDisplay: Observer, DisplayElement {
    var id: Int = 12
    
    static func == (lhs: ForecastDisplay, rhs: ForecastDisplay) -> Bool {
        true
    }
    
    var humidity: Float? = nil
    var weatherData: WeatherData? = nil
    
    init(weatherData: WeatherData) {
        self.weatherData = weatherData
        weatherData.registerObserver(o: self)
    }
    
    
    func display() {
        print("Tomorrows humidity is: \(humidity)")
    }
    
    func update(_ newObject: WeatherDataObject) {
        self.humidity = newObject.humidity
        display()
    }
}

let currentCondition = CurrentConditionsDisplay(weatherData: weatherData)
let forecast = ForecastDisplay(weatherData: weatherData)
weatherData.notifyObservers()
weatherData.notifyObservers()
weatherData.notifyObservers()

print("Complete")
