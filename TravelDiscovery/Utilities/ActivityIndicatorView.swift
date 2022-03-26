//
//  ActivityIndicatorView.swift
//  TravelDiscovery
//
//  Created by Mohammed Hamdi on 31/08/2021.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ActivityIndicatorView()
            Text("Loading...")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
        }
        .padding()
        .background(Color.black)
        .cornerRadius(8)
    }
}

struct ActivityIndicatorView: UIViewRepresentable {
    
    typealias UIViewType = UIActivityIndicatorView
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.startAnimating()
        aiv.color = .white
        return aiv
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }
}

struct ActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            ActivityIndicatorView()
        }
    }
}
