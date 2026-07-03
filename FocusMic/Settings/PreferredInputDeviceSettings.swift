import Foundation

/// 首选输入设备的持久化配置。
///
/// 只保存稳定的 UID（并附带名称用于 UID 变化时的兜底匹配），不保存运行时的 AudioObjectID。
enum PreferredInputDeviceSettings {
    private static let preferredUIDKey = "preferredInputDeviceUID"
    private static let preferredNameKey = "preferredInputDeviceName"
    private static let enabledKey = "keepPreferredInputEnabled"

    static var preferredUID: String? {
        get { UserDefaults.standard.string(forKey: preferredUIDKey) }
        set { UserDefaults.standard.set(newValue, forKey: preferredUIDKey) }
    }

    static var preferredName: String? {
        get { UserDefaults.standard.string(forKey: preferredNameKey) }
        set { UserDefaults.standard.set(newValue, forKey: preferredNameKey) }
    }

    /// 是否启用「保持首选输入设备为默认」守护。
    static var isEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: enabledKey) }
        set { UserDefaults.standard.set(newValue, forKey: enabledKey) }
    }
}
