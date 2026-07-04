import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        PreferredInputDeviceKeeper.shared.start()
        // 直发版：启动 Sparkle 定时检查；商店版为空实现。
        UpdaterService.shared.start()
    }

    func applicationWillTerminate(_ notification: Notification) {
        PreferredInputDeviceKeeper.shared.stop()
    }
}
