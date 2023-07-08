//
//  UtilityViews.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/22.
//

import SwiftUI

enum UtilityViewType {
    case indicater
}

struct UtilityViews: View {
    
    var viewType: UtilityViewType
    
    var body: some View {
        
        if viewType == .indicater{
            ActivityIndicator()
        }else{
            Spacer()
        }
    }
}

struct ActivityIndicator: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: .large)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        uiView.startAnimating()
    }
    
}

struct UtilityViews_Previews: PreviewProvider {
    static var previews: some View {
        UtilityViews(viewType: .indicater)
    }
}
