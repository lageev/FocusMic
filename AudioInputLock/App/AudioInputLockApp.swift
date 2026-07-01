import SwiftUI

@main
struct AudioInputLockApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var keeper = PreferredInputDeviceKeeper.shared

    var body: some Scene {
        MenuBarExtra {
            MenuBarContentView()
                .environment(keeper)
        } label: {
            Image(systemName: menuBarSymbol)
        }
        .menuBarExtraStyle(.window)

        Window("AudioInputLock", id: WindowID.main) {
            MainView()
                .environment(keeper)
        }
        .windowResizability(.contentSize)
        .defaultLaunchBehavior(.suppressed)
    }

    /// 菜单栏图标随守护状态变化：开启且目标在线用实心，否则用斜杠。
    private var menuBarSymbol: String {
        keeper.isEnabled && keeper.isPreferredAvailable ? "mic.fill" : "mic.slash"
    }
}

enum WindowID {
    static let main = "main"
}
