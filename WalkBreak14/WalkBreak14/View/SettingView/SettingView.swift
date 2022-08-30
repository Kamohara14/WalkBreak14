//
//  SettingView.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/08/25.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var viewModel = SettingViewModel()
    
    var body: some View {
        ZStack {
            
            Color.green.ignoresSafeArea(edges: .top)
            Color.white
            
            VStack {
                Spacer()
                Form {
                    Section(header: Text("通知許可")) {
                        Toggle(isOn: $viewModel.noticePermit) {
                            Text(viewModel.noticePermit ? "通知ON" : "通知OFF")
                        }
                    } // Section
                } // Form
            } // VS
        } // ZS
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
