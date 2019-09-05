import UIKit

enum Activity: Int {
    case location
    case audio
}

struct UIConfig {
    let activeTitle: String
    let inactiveTitle: String
    let buttonActiveColor: UIColor
    let buttonInactiveColor: UIColor
    let backgroundActiveColor: UIColor
    let backgroundInactiveColor: UIColor
}

extension Activity {
    func config() -> UIConfig {
        switch self {
        case .location:
            return UIConfig(activeTitle: "Stop Location Updates",
                            inactiveTitle: "Start Location Updates",
                            buttonActiveColor: UIColor(red: 0.43, green: 0.54, blue: 0.93, alpha: 1.00),
                            buttonInactiveColor: UIColor(red: 0.43, green: 0.54, blue: 0.93, alpha: 1.00),
                            backgroundActiveColor: UIColor(red: 0.43, green: 0.54, blue: 0.93, alpha: 0.3),
                            backgroundInactiveColor: .white)
        case .audio:
            return UIConfig(activeTitle: "Stop Audio",
                            inactiveTitle: "Start Audio",
                            buttonActiveColor: UIColor(red: 1.00, green: 0.19, blue: 0.41, alpha: 1.00),
                            buttonInactiveColor: UIColor(red: 1.00, green: 0.19, blue: 0.41, alpha: 1.00),
                            backgroundActiveColor: UIColor(red: 1.00, green: 0.19, blue: 0.41, alpha: 0.3),
                            backgroundInactiveColor: .white)
        }
    }
}

extension UserDefaults {

    private static let activityKey = "Activity"

    var activity: Activity {
        get { return Activity(rawValue: integer(forKey: UserDefaults.activityKey)) ?? .location }
        set {  set(newValue.rawValue, forKey: UserDefaults.activityKey) }
    }
}
