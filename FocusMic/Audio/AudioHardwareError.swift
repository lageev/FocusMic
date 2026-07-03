import Foundation
import CoreAudio

enum AudioHardwareError: Error, CustomStringConvertible {
    case getPropertySizeFailed(selector: AudioObjectPropertySelector, status: OSStatus)
    case getPropertyDataFailed(selector: AudioObjectPropertySelector, status: OSStatus)
    case setPropertyDataFailed(selector: AudioObjectPropertySelector, status: OSStatus)
    case invalidData

    var description: String {
        switch self {
        case let .getPropertySizeFailed(selector, status):
            return "Get property size failed. selector=\(selector), status=\(status)"
        case let .getPropertyDataFailed(selector, status):
            return "Get property data failed. selector=\(selector), status=\(status)"
        case let .setPropertyDataFailed(selector, status):
            return "Set property data failed. selector=\(selector), status=\(status)"
        case .invalidData:
            return "Invalid Core Audio data."
        }
    }
}
