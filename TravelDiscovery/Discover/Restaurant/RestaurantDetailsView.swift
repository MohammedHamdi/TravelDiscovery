//
//  RestaurantDetailsView.swift
//  TravelDiscovery
//
//  Created by Mohammed Hamdi on 06/09/2021.
//

import SwiftUI
import Kingfisher

struct RestaurantDetailsView: View {
    
    @ObservedObject var vm: RestaurantDetailsViewModel
    
    let restaurant: Restaurant
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        self.vm = RestaurantDetailsViewModel(id: restaurant.id)
    }
    
    var body: some View {
        
        if vm.isLoading {
            LoadingView()
        } else {
        
            ZStack {
                
                if !vm.errorMessage.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "xmark.octagon.fill")
                            .font(.system(size: 64, weight: .semibold))
                            .foregroundColor(.red)
                        Text(vm.errorMessage)
                            .font(.system(size: 17, weight: .bold))
                    }
                }
                
                ScrollView {
                
                ZStack(alignment: .bottomLeading) {
                    KFImage(URL(string: vm.details?.thumbnail ?? ""))
                        .resizable()
                        .scaledToFill()
                    
                    LinearGradient(gradient: .init(colors: [.clear, .black]), startPoint: .center, endPoint: .bottom)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(vm.details?.name ?? "")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold))
                            
                            HStack {
                                ForEach(0..<5, id: \.self) { num in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        NavigationLink(
                            destination: RestaurantPhotosView(photoURLStrings: vm.details?.photos ?? []),
                            label: {
                                Text("See more photos")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .regular))
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 80)
                            })
                        
                    }
                    .padding()
                }
    //            .frame(height: 250)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Location & Description")
                        .font(.system(size: 16, weight: .bold))
                    
                    let location = "\(vm.details?.city ?? ""), \(vm.details?.country ?? "")"
                    Text(location)
                
                    HStack {
                        ForEach(0..<3, id: \.self) { num in
                            Image(systemName: "dollarsign.circle.fill")
                                .foregroundColor(.orange)
                        }
                    }
                    
                    HStack { Spacer() }
                    
                }
                .padding(.top)
                .padding(.horizontal)
                
                Text(vm.details?.description ?? "")
                    .font(.system(size: 15, weight: .regular))
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                
                HStack {
                    Text("Popular Dishes")
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(vm.details?.popularDishes ?? [], id: \.self) { dish in
                            DishCell(dish: dish)
                        }
                    }
                    .padding(.horizontal)
                }
                
                if let reviews = vm.details?.reviews {
                    ReviewsList(reviews: reviews)
                }
                
            }
                .navigationBarTitle("Restaurant Details", displayMode: .inline)
            }
        }
    }
}

struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantDetailsView(restaurant: .init(id: 0, name: "Japan's Finest Tapas", imageName: "tapas"))
        }
        DiscoverView()
    }
}


class RestaurantDetailsViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var details: RestaurantDetails?
    
    @Published var errorMessage = ""
    
    init(id: Int) {
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/restaurant?id=\(id)"
        
        guard let url = URL(string: urlString) else {
            self.isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                
                // Check status code and error
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 400 {
                    self.isLoading = false
                    self.errorMessage = "Bad Status: \(statusCode)"
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    self.details = try JSONDecoder().decode(RestaurantDetails.self, from: data)
                } catch {
                    print("Error decoding restaurant details: ", error)
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }
            
        }.resume()
    }
}

struct RestaurantDetails: Decodable {
    let name, city, country, thumbnail, description: String
    let popularDishes: [Dish]
    let photos: [String]
    let reviews: [Review]
}

struct Dish: Decodable, Hashable {
    let name, price, photo: String
    let numPhotos: Int
}

struct Review: Decodable, Hashable {
    let rating: Int
    let text: String
    let user: ReviewUser
}

struct ReviewUser: Decodable, Hashable {
    let id: Int
    let username, firstName, lastName, profileImage: String
}

struct DishCell: View {
    
    let dish: Dish
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
                KFImage(URL(string: dish.photo))
                    .resizable()
                    .scaledToFill()
                    
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                    .shadow(radius: 2)
                    .padding(.vertical, 2)
                
                LinearGradient(gradient: .init(colors: [.clear, .black]), startPoint: .center, endPoint: .bottom)
                
                Text(dish.price)
                    .foregroundColor(.white)
                    .font(.system(size: 12, weight: .regular))
                    .padding(.horizontal, 6)
                    .padding(.bottom, 4)
            }
            .frame(height: 120)
            .cornerRadius(5)
            
            Text(dish.name)
                .font(.system(size: 14, weight: .bold))
            
            Text("\(dish.numPhotos) photos")
                .foregroundColor(.gray)
                .font(.system(size: 13, weight: .bold))
        }
    }
}


struct ReviewsList: View {
    
    let reviews: [Review]
    
    var body: some View {
        HStack {
            Text("Customer Reviews")
                .font(.system(size: 16, weight: .bold))
            
            Spacer()
        }
        .padding(.horizontal)
        
        ForEach(reviews, id: \.self) { review in
            
            VStack(alignment: .leading) {
                HStack {
                    
                    KFImage(URL(string: review.user.profileImage))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(review.user.firstName) \(review.user.lastName)")
                            .font(.system(size: 14, weight: .bold))
                        
                        HStack(spacing: 0) {
                            ForEach(0..<review.rating, id: \.self) { num in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.orange)
                            }
                            
                            ForEach(review.rating..<5, id: \.self) { num in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .font(.system(size: 14))
                    }
                    
                    Spacer()
                    
                    Text("Dec 2020")
                        .font(.system(size: 14, weight: .regular))
                }
                Text(review.text)
                    .font(.system(size: 14, weight: .regular))
            }
            .padding(.top)
            .padding(.horizontal)
            
        }
    }
}
