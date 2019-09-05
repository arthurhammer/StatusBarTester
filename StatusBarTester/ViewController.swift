import UIKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var button: UIButton!
    @IBOutlet var activityChooser: UISegmentedControl!
    @IBOutlet var backgroundView: UIView!  // Layered on top of the white background view for alpha colors.

    lazy var locationManager = CLLocationManager()
    lazy var audioEngine = AVAudioEngine()
    lazy var defaults = UserDefaults.standard

    private var isActive: Bool {
        return isLocationActive || audioEngine.isRunning
    }

    private var isLocationActive = false {
        didSet { update() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())

        update()
    }

    @IBAction private func chooseActivity(_ sender: UISegmentedControl) {
        defaults.activity = Activity(rawValue: sender.selectedSegmentIndex)!
        stopActivity()
        update()
    }

    @IBAction func toggleActivity() {
        if isActive {
            stopActivity()
        } else {
            startActivity()
        }
    }

    private func startActivity() {
        switch defaults.activity {
        case .location: startLocation()
        case .audio: startAudio()
        }
    }

    private func stopActivity() {
        stopLocation()
        stopAudio()
    }

    private func startLocation() {
        stopAudio()

        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers

        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            isLocationActive = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        update()
    }

    private func stopLocation() {
        guard isLocationActive else { return }
        locationManager.stopUpdatingLocation()
        isLocationActive = false
        update()
    }

    private func startAudio() {
        stopLocation()
        _ = audioEngine.inputNode  // Initialized on first access.
        try? audioEngine.start()  // Ignoring.
        update()
    }

    private func stopAudio() {
        guard audioEngine.isRunning else { return }
        audioEngine.stop()
        update()
    }

    private func update() {
        let config = defaults.activity.config()

        let title = isActive ? config.activeTitle : config.inactiveTitle
        let buttonColor = isActive ? config.buttonActiveColor : config.buttonInactiveColor
        let backgroundColor = isActive ? config.backgroundActiveColor : config.backgroundInactiveColor

        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        
        activityChooser.tintColor = .gray
        activityChooser.selectedSegmentIndex = defaults.activity.rawValue

        UIView.animate(withDuration: 0.15) {
            self.button.backgroundColor = buttonColor
            self.backgroundView.backgroundColor = backgroundColor
        }
    }

    @objc private func handleInterruption(_ notification: Notification) {
        update()
    }
}
