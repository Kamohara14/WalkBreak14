//
//  NoticeView.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/08/23.
//

import SwiftUI

struct NoticeView: View {
    // viewModel
    @ObservedObject var viewModel: WalkBreakViewModel
    
    // カスタマイズした戻る処理
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            
            Color.green.ignoresSafeArea(edges: .top)
            Color.white
            
            VStack {
                
                // 空白を開ける
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                ScrollView {
                    // 通知を表示
                    NoticeParts(viewModel: viewModel)
                    
                } // Scroll
            } // VS
        } // ZS
        .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button{
                                // 戻る
                                dismiss()
                            } label: {
                                HStack {
                                    Image(systemName: "chevron.backward")
                                        .font(.system(size: 17, weight: .medium))
                                    Text("ホームへ")
                                }
                                .foregroundColor(.white)
                            }
                        }
                    }
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView(viewModel: WalkBreakViewModel())
    }
}

// 通知を作成し表示するView
struct NoticeParts: View {
    
    @ObservedObject var viewModel: WalkBreakViewModel

    var body: some View {
        VStack {
            ForEach (viewModel.noticeArray) { notice in
                
                VStack {
                    HStack {
                        Text(notice.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding([.top, .leading, .bottom])
                        
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        
                        Text(notice.date)
                            .font(.headline)
                            .fontWeight(.thin)
                            .padding([.bottom, .trailing])
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .background(
                    Rectangle()
                        .fill(Color(red: 0.94, green: 0.94, blue: 0.94))
                    
                )
                .padding(.horizontal)
            }
            
        }
    }
}
