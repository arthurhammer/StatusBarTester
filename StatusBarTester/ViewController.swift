import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var button: UIButton!

    lazy var locationManager = CLLocationManager()

    var isUpdating = false {
        didSet { update() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers

        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        
        update()
    }

    @IBAction func toggleLocationUpdates() {
        if isUpdating {
            locationManager.stopUpdatingLocation()
            isUpdating = false
            return
        }

        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            isUpdating = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func update() {
        let title = isUpdating ? "Stop Location Updates" : "Start Location Updates"
        let color = isUpdating ?  UIColor(red: 1.00, green: 0.19, blue: 0.41, alpha: 1.00) : UIColor(red: 0.43, green: 0.54, blue: 0.93, alpha: 1.00)
        let backgroundColor = isUpdating ? color.withAlphaComponent(0.2) : .white

        self.button.setTitle(title, for: .normal)

        UIView.animate(withDuration: 0.15) {
            self.button.backgroundColor = color
            self.backgroundView.backgroundColor = backgroundColor
        }
    }
}
