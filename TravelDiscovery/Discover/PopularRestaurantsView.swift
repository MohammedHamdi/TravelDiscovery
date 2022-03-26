//
//  PopularRestaurantsView.swift
//  TravelDiscovery
//
//  Created by Mohammed Hamdi on 30/08/2021.
//

import SwiftUI

struct PopularRestaurantsView: View {
    
    let restaurants: [Restaurant] = [
        .init(id: 0, name: "Japan's Finest Tapas", imageName: "tapas"),
        .init(id: 1, name: "Grill", imageName: "grill")
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Popular places to eat")
                    .font(.system(size: 14, weight: .semibold))
                
                Spacer()
                
                Text("See all")
                    .font(.system(size: 12, weight: .semibold))
            }
            .padding(.horizontal)
            .padding(.top)
            
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(restaurants, id: \.self) { restaurant in
                        
                        
                        NavigationLink(
                            destination: NavigationLazyView(RestaurantDetailsView(restaurant: restaurant)),
                            label: {
                                RestaurantTile(restaurant: restaurant)
                                    .foregroundColor(Color(.label))
                            })
                        
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}

struct PopularRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        PopularRestaurantsView()
        DiscoverView()
    }
}

struct RestaurantTile: View {
    
    let restaurant: Restaurant
    
    var body: some View {
        HStack(spacing: 8) {
            Image(restaurant.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipped()
                .background(Color.gray)
                .cornerRadius(4)
                .padding(.leading, 6)
                .padding(.vertical, 6)
            
            VStack(alignment: .leading, spacing: 6) {
                
                HStack {
                    Text(restaurant.name)
                    
                    Spacer()
                    
                    Button(action: {}, label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                    })
                    
                }
                
                HStack {
                    Image(systemName: "star.fill")
                    
                    Text("4.7 • Sushi • $$")
                }
                
                Text("Tokyo, Japan")
            }
            .font(.system(size: 12, weight: .semibold))
            
            Spacer()
        }
        .frame(width: 240)
        .asTile()
    }
}
