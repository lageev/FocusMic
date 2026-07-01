import CoreAudio

/// 对 Core Audio 硬件属性读写的封装：枚举设备、读取名称/UID/通道数、读写系统默认输入设备。
final class AudioHardwareService {

    static let shared = AudioHardwareService()

    private let systemObject = AudioObjectID(kAudioObjectSystemObject)

    private init() {}

    // MARK: - Address 构造

    private func address(
        _ selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal
    ) -> AudioObjectPropertyAddress {
        AudioObjectPropertyAddress(
            mSelector: selector,
            mScope: scope,
            mElement: kAudioObjectPropertyElementMain
        )
    }

    // MARK: - 枚举设备

    func getAllAudioDeviceIDs() throws -> [AudioObjectID] {
        var address = self.address(kAudioHardwarePropertyDevices)

        var dataSize: UInt32 = 0
        var status = AudioObjectGetPropertyDataSize(systemObject, &address, 0, nil, &dataSize)
        guard status == noErr else {
            throw AudioHardwareError.getPropertySizeFailed(selector: address.mSelector, status: status)
        }
        guard dataSize > 0 else { return [] }

        let count = Int(dataSize) / MemoryLayout<AudioObjectID>.size
        var deviceIDs = [AudioObjectID](repeating: 0, count: count)

        status = AudioObjectGetPropertyData(systemObject, &address, 0, nil, &dataSize, &deviceIDs)
        guard status == noErr else {
            throw AudioHardwareError.getPropertyDataFailed(selector: address.mSelector, status: status)
        }
        return deviceIDs
    }

    /// 只返回具备输入通道的设备，并标注当前默认输入。
    func getInputDevices() -> [AudioInputDevice] {
        let defaultInputID = getDefaultInputDeviceID()
        guard let allDeviceIDs = try? getAllAudioDeviceIDs() else { return [] }

        return allDeviceIDs.compactMap { deviceID in
            let channelCount = getInputChannelCount(deviceID)
            guard channelCount > 0, let uid = getDeviceUID(deviceID) else { return nil }

            return AudioInputDevice(
                id: deviceID,
                uid: uid,
                name: getDeviceName(deviceID) ?? "Unknown Input Device",
                inputChannelCount: channelCount,
                isDefaultInput: defaultInputID == deviceID
            )
        }
    }

    // MARK: - 设备属性

    func getDeviceName(_ deviceID: AudioObjectID) -> String? {
        var address = self.address(kAudioObjectPropertyName)
        var name: CFString = "" as CFString
        var dataSize = UInt32(MemoryLayout<CFString>.size)

        let status = AudioObjectGetPropertyData(deviceID, &address, 0, nil, &dataSize, &name)
        return status == noErr ? name as String : nil
    }

    func getDeviceUID(_ deviceID: AudioObjectID) -> String? {
        var address = self.address(kAudioDevicePropertyDeviceUID)
        var uid: CFString = "" as CFString
        var dataSize = UInt32(MemoryLayout<CFString>.size)

        let status = AudioObjectGetPropertyData(deviceID, &address, 0, nil, &dataSize, &uid)
        return status == noErr ? uid as String : nil
    }

    func getInputChannelCount(_ deviceID: AudioObjectID) -> UInt32 {
        var address = self.address(kAudioDevicePropertyStreamConfiguration, scope: kAudioDevicePropertyScopeInput)

        var dataSize: UInt32 = 0
        guard AudioObjectGetPropertyDataSize(deviceID, &address, 0, nil, &dataSize) == noErr,
              dataSize > 0 else {
            return 0
        }

        let rawPointer = UnsafeMutableRawPointer.allocate(
            byteCount: Int(dataSize),
            alignment: MemoryLayout<AudioBufferList>.alignment
        )
        defer { rawPointer.deallocate() }

        let bufferListPointer = rawPointer.assumingMemoryBound(to: AudioBufferList.self)
        var size = dataSize
        guard AudioObjectGetPropertyData(deviceID, &address, 0, nil, &size, bufferListPointer) == noErr else {
            return 0
        }

        return UnsafeMutableAudioBufferListPointer(bufferListPointer).reduce(UInt32(0)) {
            $0 + $1.mNumberChannels
        }
    }

    func isInputDevice(_ deviceID: AudioObjectID) -> Bool {
        getInputChannelCount(deviceID) > 0
    }

    // MARK: - 默认输入设备

    func getDefaultInputDeviceID() -> AudioObjectID? {
        var address = self.address(kAudioHardwarePropertyDefaultInputDevice)
        var deviceID = AudioObjectID(0)
        var dataSize = UInt32(MemoryLayout<AudioObjectID>.size)

        let status = AudioObjectGetPropertyData(systemObject, &address, 0, nil, &dataSize, &deviceID)
        guard status == noErr, deviceID != 0 else { return nil }
        return deviceID
    }

    @discardableResult
    func setDefaultInputDevice(_ deviceID: AudioObjectID) throws -> Bool {
        var address = self.address(kAudioHardwarePropertyDefaultInputDevice)
        var targetDeviceID = deviceID
        let dataSize = UInt32(MemoryLayout<AudioObjectID>.size)

        let status = AudioObjectSetPropertyData(systemObject, &address, 0, nil, dataSize, &targetDeviceID)
        guard status == noErr else {
            throw AudioHardwareError.setPropertyDataFailed(selector: address.mSelector, status: status)
        }
        return true
    }
}
