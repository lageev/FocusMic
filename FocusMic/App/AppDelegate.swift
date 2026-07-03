import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        PreferredInputDeviceKeeper.shared.start()
    }

    func applicationWillTerminate(_ notification: Notification) {
        PreferredInputDeviceKeeper.shared.stop()
    }
}
