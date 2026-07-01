import CoreAudio

/// 输入设备信息模型。
///
/// `id` 是 Core Audio 运行时对象 ID，插拔或重启后可能变化；
/// 需要持久化时应使用稳定的 `uid`。
struct AudioInputDevice: Identifiable, Equatable {
    let id: AudioObjectID
    let uid: String
    let name: String
    let inputChannelCount: UInt32
    let isDefaultInput: Bool

    /// 便于 UI 展示的简短 UID（区分多个同名设备）。
    var shortUID: String {
        uid.count > 28 ? "…" + uid.suffix(26) : uid
    }
}
