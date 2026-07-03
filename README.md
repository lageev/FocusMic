# FocusMic

[简体中文](README.zh-CN.md) | [Website](https://focusmic.yayalu.top/) | [Latest Release](https://github.com/lageev/FocusMic/releases/latest)

Never lose your mic while vibecoding.

FocusMic is a lightweight macOS menu bar app that keeps the system default audio input locked to the microphone you choose. If macOS, a Bluetooth headset, a USB interface, or another app switches the default input, FocusMic switches it back when guard mode is enabled.

## Why

macOS often changes the default input device when you plug in a new USB microphone, connect a Bluetooth headset, dock your Mac, or wake from sleep. That is easy to miss until a call starts with the wrong mic.

FocusMic watches Core Audio device changes, remembers your preferred input device, and restores it automatically without recording or listening to any audio.

## Features

- **Menu bar workflow**: check status, toggle guard mode, refresh devices, and switch inputs from the menu bar.
- **Preferred input lock**: pick a microphone once and keep it as the system default input.
- **Hot-plug aware**: detects input device list changes and re-applies your preference when the device returns.
- **Event-driven monitoring**: listens to Core Audio hardware events instead of polling in the background.
- **Debounced enforcement**: waits briefly after noisy system events to avoid repeated switching.
- **Activity log**: keeps the latest device switch and guard actions in the app.
- **Launch at login**: optionally starts FocusMic when you sign in.
- **Privacy-friendly**: no account, no analytics, no network requests, and no audio capture.

## Requirements

- macOS 15.0 or later
- Xcode 16 or later with macOS 15 SDK support

The app uses SwiftUI, Core Audio, Observation, and ServiceManagement.

## Download

Download the latest build from [GitHub Releases](https://github.com/lageev/FocusMic/releases/latest).

To run from source:

1. Clone this repository.
2. Open `FocusMic.xcodeproj` in Xcode.
3. Select the `FocusMic` scheme and run it from Xcode.

## Usage

1. Launch FocusMic.
2. Click the menu bar icon.
3. Select the input device you want to lock.
4. Enable **Guard input device**.
5. Optionally open the main window to enable launch at login or inspect recent activity.

When guard mode is on and the preferred device is online, FocusMic keeps that device as the system default input. When the preferred device is offline, FocusMic waits for it to come back.

## Status States

FocusMic derives its status from your selected device, the current system default input, and guard mode:

| State | Meaning |
| --- | --- |
| No locked device | Pick an input device to start. |
| Locked and guarded | The preferred device is the current system input and guard mode is enabled. |
| Selected but unguarded | The preferred device is selected, but automatic switching is disabled. |
| Waiting to switch back | Another device became default while guard mode is enabled. |
| Device offline | The preferred device is unavailable and will be restored when it reconnects. |

## How It Works

FocusMic uses [Core Audio](https://developer.apple.com/documentation/coreaudio) to:

- enumerate input devices with `kAudioHardwarePropertyDevices`;
- read and write `kAudioHardwarePropertyDefaultInputDevice`;
- listen for device list and default input changes with `AudioObjectAddPropertyListenerBlock`.

When a change is detected, FocusMic refreshes the input device list, waits for a short debounce window, and writes the preferred input device back as the system default if guard mode is enabled and the device is available.

## Privacy

FocusMic runs locally on your Mac.

- It does not record, listen to, upload, or analyze audio.
- It does not make network requests.
- It does not include analytics, ads, tracking, or crash reporting.
- It stores only local preferences in `UserDefaults`: preferred device UID/name, guard switch state, and the recent activity log.

See the [Privacy Policy](https://focusmic.yayalu.top/privacy) for the full text.

## Project Structure

```text
.
├── FocusMic.xcodeproj/     # Xcode project
├── FocusMic/
│   ├── App/                # App entry point, delegate, and brand constants
│   ├── Audio/              # Core Audio hardware layer and guard coordinator
│   ├── Settings/           # UserDefaults and launch-at-login integration
│   ├── UI/                 # SwiftUI menu bar, settings, rows, and log views
│   ├── Assets.xcassets/    # App icons and colors
│   └── IconSources/        # Source SVG/icon assets
├── landing/                # Static product site, terms, privacy, and i18n
├── README.md
└── README.zh-CN.md
```

## Links

- [Website](https://focusmic.yayalu.top/)
- [Terms](https://focusmic.yayalu.top/terms)
- [Privacy](https://focusmic.yayalu.top/privacy)
- [Issues](https://github.com/lageev/FocusMic/issues)

## License

MIT
