//
//  UserDetailsView.swift
//  TravelDiscovery
//
//  Created by Mohammed Hamdi on 08/09/2021.
//

import SwiftUI
import Kingfisher

struct UserDetailsView: View {
    
    let user: User
    
    @ObservedObject var vm: UserDetailsViewModel
    
    init(user: User) {
        self.vm = UserDetailsViewModel(id: user.id)
        self.user = user
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
                
                VStack(spacing: 12) {
                    
                    KFImage(URL(string: vm.userDetails?.profileImage ?? ""))
//                        .placeholder()
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    let name = vm.userDetails == nil ? user.name : "\(vm.userDetails!.firstName) \(vm.userDetails!.lastName)"
                    Text(name)
                        .font(.system(size: 14, weight: .semibold))
                    
                    HStack {
                        Text("@\(vm.userDetails?.username ?? "") •")
                        
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.system(size: 10, weight: .semibold))
                        
                        Text("5364")
                    }
                    .font(.system(size: 12, weight: .regular))
                    
                    Text("Youtuber, Creator, Bla Bla")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(.lightGray))
                    
                    HStack(spacing: 12) {
                        VStack {
                            Text("\(vm.userDetails?.followers ?? 0)")
                                .font(.system(size: 13, weight: .semibold))
                            Text("Followers")
                                .font(.system(size: 9, weight: .regular))
                        }
                        
                        Spacer()
                            .frame(width: 1, height: 12)
                            .background(Color(.lightGray))
                        
                        VStack {
                            Text("\(vm.userDetails?.following ?? 0)")
                                .font(.system(size: 13, weight: .semibold))
                            Text("Following")
                                .font(.system(size: 9, weight: .regular))
                        }
                    }
                    
                    HStack(spacing: 12) {
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            HStack {
                                Spacer()
                                Text("Follow")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .cornerRadius(100)
                        })
                        
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            HStack {
                                Spacer()
                                Text("Contact")
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .background(Color(white: 0.9))
                            .cornerRadius(100)
                        })
                    }
                    .font(.system(size: 12, weight: .semibold))
                    
                    
                    ForEach(vm.userDetails?.posts ?? [], id: \.self) { post in
                        
                        VStack(alignment: .leading) {
                            KFImage(URL(string: post.imageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                            
                            HStack {
                                KFImage(URL(string: vm.userDetails?.profileImage ?? ""))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 34)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading) {
                                    Text(post.title)
                                        .font(.system(size: 14, weight: .semibold))
                                    
                                    Text("\(post.views) views")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(.gray)
                                }
                                
                            }
                            .padding(.horizontal, 8)
                            
                            HStack {
                                ForEach(post.hashtags, id: \.self) { hashtag in
                                    Text("#\(hashtag)")
                                        .foregroundColor(Color(#colorLiteral(red: 0.07797152549, green: 0.513774395, blue: 0.9998757243, alpha: 1)))
                                        .font(.system(size: 14, weight: .semibold))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(Color(#colorLiteral(red: 0.9057956338, green: 0.9333867431, blue: 0.9763537049, alpha: 1)))
                                        .cornerRadius(20)
                                }
                            }
                            .padding(.bottom)
                            .padding(.horizontal, 12)
                            
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .init(white: 0.8), radius: 5, x: 0, y: 4)
                    }
                    
                }
                .padding(.horizontal)
            }
                .navigationBarTitle(user.name, displayMode: .inline)
            }
        }
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserDetailsView(user: .init(id: 0, name: "Amy Adams", imageName: "amy"))
        }
    }
}

class UserDetailsViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var userDetails: UserDetails?
    
    @Published var errorMessage = ""
    
    init(id: Int) {
        
        guard let url = URL(string: "https://travel.letsbuildthatapp.com/travel_discovery/user?id=\(id)") else {
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
                    self.userDetails = try JSONDecoder().decode(UserDetails.self, from: data)
                } catch {
                    print("Error decoding user details: ", error)
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }
        }.resume()
    }
}

struct UserDetails: Decodable {
    let username, firstName, lastName, profileImage: String
    let followers, following: Int
    let posts: [Post]
}

struct Post: Decodable, Hashable {
    let title, imageUrl, views: String
    let hashtags: [String]
}
