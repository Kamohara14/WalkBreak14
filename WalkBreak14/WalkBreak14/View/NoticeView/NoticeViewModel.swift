//
//  NoticeViewModel.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/08/23.
//

import Foundation

final class NoticeViewModel: ObservableObject {
    
    // Model
    private let noticeManager = NoticeManager()
    
    // 通知を入れる配列
    @Published var noticeArray: [Notice] = []
    
    init() {
        // 起動時に反映
        self.noticeArray = noticeManager.getNotice()
    }
}
