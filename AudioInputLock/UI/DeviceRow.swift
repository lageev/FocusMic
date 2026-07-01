import SwiftUI

/// 单个输入设备行：勾选表示首选设备，徽标表示当前系统默认输入。点击即设为首选。
struct DeviceRow: View {
    let device: AudioInputDevice
    let isPreferred: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: isPreferred ? "checkmark.circle.fill" : "circle")
                    .imageScale(.large)
                    .foregroundStyle(isPreferred ? Color.accentColor : Color.secondary)

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(device.name)
                        if device.isDefaultInput {
                            Text("当前默认")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.accentColor.opacity(0.15), in: Capsule())
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    Text("\(device.inputChannelCount) 通道 · \(device.shortUID)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
