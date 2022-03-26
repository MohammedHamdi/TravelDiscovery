//
//  RestaurantPhotosView.swift
//  TravelDiscovery
//
//  Created by Mohammed Hamdi on 07/09/2021.
//

import SwiftUI
import Kingfisher

struct RestaurantPhotosView: View {
    
    let photoURLStrings: [String]
    
    @State var mode = "grid"
    @State var shouldShowFullscreenModal = false
    @State var selectedPhotoIndex = 0
    
    init(photoURLStrings: [String]) {
        self.photoURLStrings = photoURLStrings
        
        UISegmentedControl.appearance().backgroundColor = .black
        UISegmentedControl.appearance().selectedSegmentTintColor = .orange
        
        let titleTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttribute, for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttribute, for: .normal)
    }
    
    var body: some View {
        
        GeometryReader { proxy in
            ScrollView {
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldShowFullscreenModal, content: {
                        ZStack(alignment: .topLeading) {
                            Color.black
                                .ignoresSafeArea()
                            
                            TabView(selection: $selectedPhotoIndex,
                                    content:  {
                                        ForEach(photoURLStrings, id: \.self) { urlString in
                                            KFImage(URL(string: urlString))
                                                .resizable()
                                                .scaledToFit()
                                                .tag(photoURLStrings.firstIndex(of: urlString) ?? 0)
                                        }
                                    })
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                            
//                            RestaurantCarouselContainer(imageUrlStrings: photoURLStrings, selectedIndex: selectedPhotoIndex)
                            
                            Button(action: {
                                shouldShowFullscreenModal.toggle()
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding()
                            })
                        }
                    })
//                    .opacity(shouldShowFullscreenModal ? 1 : 0)
                
                
                Picker("Test", selection: $mode) {
                    Text("Grid").tag("grid")
                    Text("List").tag("list")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if mode == "grid" {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: proxy.size.width / 3 - 4, maximum: 600), spacing: 2)
                    ], spacing: 4, content: {
                        
                        ForEach(photoURLStrings, id: \.self) { urlString in
                            
                            Button(action: {
                                selectedPhotoIndex = photoURLStrings.firstIndex(of: urlString) ?? 0
                                shouldShowFullscreenModal.toggle()
                            }, label: {
                                KFImage(URL(string: urlString))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: proxy.size.width / 3 - 3, height: proxy.size.width / 3)
                                    .clipped()
                            })
                        }
                        
                    })
                    .padding(.horizontal, 2)
                
                } else {
                    // List
                    ForEach(photoURLStrings, id: \.self) { urlString in
                        VStack(alignment: .leading, spacing: 8) {
                            KFImage(URL(string: urlString))
                                .resizable()
                                .scaledToFill()
                                .padding(.horizontal, -8)
                            
                            HStack {
                                Image(systemName: "heart")
                                Image(systemName: "bubble.right")
                                Image(systemName: "paperplane")
                                Spacer()
                                Image(systemName: "bookmark")
                            }
                            .font(.system(size: 22))
                            
                            Text("Description for the post goes here, make sure to use a bunch of lines of text otherwise you never know what's going to happen.\n\nOne more line")
                                .font(.system(size: 14))
                                
                            
                            Text("Posted on 11/11/11")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 8)
                        .padding(.bottom)
                    }
                }
                
            }
        }
        .navigationBarTitle("All Photos", displayMode: .inline)
    }
}

struct RestaurantPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantPhotosView(photoURLStrings: ["https://letsbuildthatapp-videos.s3.us-west-2.amazonaws.com/e2f3f5d4-5993-4536-9d8d-b505d7986a5c",     "https://letsbuildthatapp-videos.s3.us-west-2.amazonaws.com/a4d85eff-4c79-4141-a0d6-761cca48eae1",     "https://letsbuildthatapp-videos.s3.us-west-2.amazonaws.com/20a6783b-3de7-4e58-9e22-bcc6a43b6df6",     "https://letsbuildthatapp-videos.s3.us-west-2.amazonaws.com/0d1d2e79-2f10-4cfd-82da-a1c2ab3638d2"])
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .previewLayout(.fixed(width: 1200, height: 1200))
    }
}
