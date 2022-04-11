//
//  Home.swift
//  maptest
//
//  Created by Ali Fahad on 10.4.2022.
//

import SwiftUI
import CoreLocation
import MapKit
struct Home: View {
    @StateObject var mapData = MapViewModel()
    // Location Manager...
    @State var locationManager = CLLocationManager()
    var body: some View {
        
   
        ZStack {
            //Map View...
            MapView()
                //using it as enviorment object so it can be used as a sub view...
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            
                
            VStack{
                
                    VStack(spacing: 0) {
                            HStack{
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search", text: $mapData.searchTxt)
                            .colorScheme(.light)
                    }
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(Color.white)
                        }
                        
                        // Dispalying Results...
                        
                        if !mapData.places.isEmpty && mapData.searchTxt
                            != ""{
                            ScrollView{
                                VStack(spacing: 15){
                                    ForEach(mapData.places){place in
                                        Text(place.place.name ?? "")
                                            .foregroundColor(.mint)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading)
                                            .onTapGesture {
                                                mapData.selectPlace(place: place)
                                            }
                                        
                                        Divider()
                                    }
                                }
                                .padding(.top)
                            }
                            .background(Color.white)
                        }
                
                Spacer()

                    }
            
                    .padding()
            
                
                
                VStack{
                    Spacer()
                    Button(action: mapData.focusLocation, label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                    })
                    Button(action: mapData.updateMapType, label: {
                        Image(systemName: mapData.mapType ==
                                .standard ? "network" : "map")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                    })
                    
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
        }
            
        
        .onAppear(perform: {
            
            // Setting Delegate...
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
        })
        .alert(isPresented: $mapData.permissionDenied, content: {
            Alert(title: Text("Permission Denied"), message:
                Text("Please Enable Permission From Settings"),
                dismissButton: .default(Text("Go To Settings"),
                action:{
                //Redirect user to settings...
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
        .onChange(of: mapData.searchTxt, perform: { value in
            // searching places...
            
            let delay = 2.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay)
            {
            
                if value == mapData.searchTxt{
                    // search...
                    self.mapData.searchQuery()
                }
            }
        })
    }

}
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

