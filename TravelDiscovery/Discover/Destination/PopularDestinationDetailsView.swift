//
//  PopularDestinationDetailsView.swift
//  TravelDiscovery
//
//  Created by Mohammed Hamdi on 02/09/2021.
//

import SwiftUI
import MapKit

struct PopularDestinationDetailsView: View {
    
    @ObservedObject var vm: DestinationDetailsViewModel
    
    let destination: Destination
    
    let attractions: [Attraction] = [
        .init(name: "Eiffel Tower", imageName: "eiffel_tower", latitude: 48.858605, longitude: 2.2946),
        .init(name: "Champs-Elysees", imageName: "new_york", latitude: 48.866867, longitude: 2.311780),
        .init(name: "Louvre Museum", imageName: "art2", latitude: 48.860288, longitude: 2.337789)
    ]
    
    @State var region: MKCoordinateRegion
    @State var isShowingAttractions = true
    
    init(destination: Destination) {
        self.destination = destination
        self.region = MKCoordinateRegion(center: .init(latitude: destination.latitude, longitude: destination.longitude), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        self.vm = DestinationDetailsViewModel(name: destination.name)
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
                
                if let photos = vm.destinationDetails?.photos {
                    DestinationHeaderContainer(imageUrlStrings: photos)
                        .frame(height: 250)
                }
                
                VStack(alignment: .leading) {
                    Text(destination.name)
                        .font(.system(size: 18, weight: .bold))
                    
                    Text(destination.country)
                    
                    HStack {
                        ForEach(0..<5, id: \.self) { num in
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                        }
                    }
                    .padding(.top, 2)
                    
                    HStack {
                        Text(vm.destinationDetails?.description ?? "")
                            .font(.system(size: 14))
                            .padding(.top, 4)
    //                    .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Location")
                        .font(.system(size: 18, weight: .semibold))
                    Spacer()
                    
                    Button(action: { isShowingAttractions.toggle() }, label: {
                        Text("\(isShowingAttractions ? "Hide" : "Show") Attractions")
                            .font(.system(size: 12, weight: .semibold))
                    })
                    
                    Toggle("", isOn: $isShowingAttractions)
                        .labelsHidden()
                    
                }
                .padding(.horizontal)
                
                Map(coordinateRegion: $region, annotationItems: isShowingAttractions ? attractions : []) { attraction in
    //                MapMarker(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude), tint: .red)
                    
                    MapAnnotation(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude)) {
                        
                        CustomMapAnnotation(attraction: attraction)
                        
                    }
                }
                .frame(height: 300)
                
                
            }
                .navigationBarTitle(destination.name, displayMode: .inline)
            }
        }
    }
}

struct PopularDestinationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PopularDestinationDetailsView(destination: Destination(name: "Paris", country: "France", imageName: "eiffel_tower", latitude: 48.859565, longitude: 2.353235))
        }
    }
}


class DestinationDetailsViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var destinationDetails: DestinationDetails?
    
    @Published var errorMessage = ""
    
    init(name: String) {
        
        guard let url = URL(string: "https://travel.letsbuildthatapp.com/travel_discovery/destination?name=\(name.lowercased())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
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
                    self.destinationDetails = try JSONDecoder().decode(DestinationDetails.self, from: data)
                    
                } catch {
                    print("Failed to decode JSON: ", error)
                    self.errorMessage = error.localizedDescription
                }
                
                self.isLoading = false
            }
            
        }.resume()
    }
}

struct DestinationDetails: Decodable {
    let description: String
    let photos: [String]
}
