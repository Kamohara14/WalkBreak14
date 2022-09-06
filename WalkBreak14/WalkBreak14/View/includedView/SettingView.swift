//
//  SettingView.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/08/25.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var viewModel: WalkBreakViewModel
    
    var body: some View {
        ZStack {
            
            Color.green.ignoresSafeArea(edges: .top)
            Color.white
            
            VStack {
                Spacer()
                Form {
                    // TODO: 設定画面
                } // Form
            } // VS
        } // ZS
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(viewModel: WalkBreakViewModel())
    }
}
