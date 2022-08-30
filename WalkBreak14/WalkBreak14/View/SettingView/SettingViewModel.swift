//
//  SettingViewModel.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/08/26.
//

import Foundation

final class SettingViewModel: ObservableObject {
    // 通知許可
    @Published var noticePermit: Bool {
        didSet {
            UserDefaults.standard.set(noticePermit, forKey: "noticePermit")
        }
    }
    
    init() {
        noticePermit = UserDefaults.standard.bool(forKey: "noticePermit")
    }
}
