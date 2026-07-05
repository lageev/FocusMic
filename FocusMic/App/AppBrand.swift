import Foundation

enum AppBrand {
    static let name = "FocusMic"
    static let slogan = "Never lose your mic while vibecoding"

    /// 主窗口关于页与菜单栏关于面板共用的链接。
    static var links: [(title: String, url: String)] {
        [
            (String(localized: "官网"), "https://focusmic.yayalu.top/"),
            (String(localized: "打赏"), "https://donation.yayalu.top/"),
            (String(localized: "服务条款"), "https://focusmic.yayalu.top/terms"),
            (String(localized: "隐私政策"), "https://focusmic.yayalu.top/privacy"),
            (String(localized: "更多作品"), "https://apps.apple.com/cn/app/id6761610245")
        ]
    }
}
