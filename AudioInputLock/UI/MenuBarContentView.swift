import SwiftUI

/// 菜单栏弹出面板：快速查看状态、开关守护、切换首选设备、进入主界面或退出。
struct MenuBarContentView: View {
    @Environment(PreferredInputDeviceKeeper.self) private var keeper
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        @Bindable var keeper = keeper

        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("AudioInputLock")
                    .font(.headline)
                Text(statusText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.top, 12)

            Toggle("保持首选输入设备为默认", isOn: $keeper.isEnabled)
                .toggleStyle(.switch)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)

            Divider()

            if keeper.devices.isEmpty {
                Text("未检测到输入设备")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 16)
            } else {
                ScrollView {
                    VStack(spacing: 2) {
                        ForEach(keeper.devices) { device in
                            DeviceRow(device: device, isPreferred: device.uid == keeper.preferredUID) {
                                keeper.selectPreferred(device)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                        }
                    }
                    .padding(.vertical, 6)
                }
                .frame(maxHeight: 240)
            }

            Divider()

            HStack {
                Button("打开主界面") {
                    openWindow(id: WindowID.main)
                    NSApp.activate()
                }
                Spacer()
                Button("退出") {
                    NSApp.terminate(nil)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
        }
        .frame(width: 320)
        .onAppear { keeper.refreshDevices() }
    }

    private var statusText: String {
        guard keeper.preferredUID != nil else { return "尚未选择首选设备" }
        let name = keeper.devices.first { $0.uid == keeper.preferredUID }?.name
            ?? PreferredInputDeviceSettings.preferredName
            ?? "首选设备"
        return keeper.isPreferredAvailable ? "首选：\(name)（在线）" : "首选：\(name)（离线）"
    }
}
