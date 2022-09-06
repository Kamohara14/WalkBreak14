//
//  RecordView.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/08/16.
//

import SwiftUI

struct RecordView: View {
    
    // ViewModel
    @ObservedObject var viewModel: WalkBreakViewModel
    
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
                    RecordParts(viewModel: viewModel)
                } // Scroll
            } // VS
        }// ZS
        .onAppear {
            viewModel.updateRecord()
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView(viewModel: WalkBreakViewModel())
    }
}

struct RecordParts: View {
    
    @ObservedObject var viewModel: WalkBreakViewModel
    
    var body: some View {
        VStack {
            ForEach (viewModel.recordArray) { record in
                
                VStack {
                    HStack {
                        Text(record.date)
                            .font(.title3)
                            .padding([.top, .leading])
                        
                        Spacer()
                    }
                    HStack {
                        Text(record.content)
                            .font(.title3)
                            .padding(.leading)
                        
                        Spacer()
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                Rectangle()
                    .fill(Color(red: 0.94, green: 0.94, blue: 0.94))
                    .frame(maxHeight: 4)
                    .padding()
            } // ForEach
            
        } // VS
    }
}
