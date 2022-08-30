//
//  NoticeView.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/08/23.
//

import SwiftUI

struct NoticeView: View {
    // 通知のviewModel
    @ObservedObject var viewModel = NoticeViewModel()
    
    var body: some View {
        ZStack {
            
            Color.green.ignoresSafeArea(edges: .top)
            Color.white
            
            VStack {
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                ScrollView {
                    NoticeParts(viewModel: viewModel)
                } // Scroll
            } // VS
        } // ZS
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView()
    }
}

struct NoticeParts: View {
    
    @ObservedObject var viewModel: NoticeViewModel
    
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
