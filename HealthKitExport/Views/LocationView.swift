//
//  LocationView.swift
//  HealthKitExport
//
//  Created by Adam Older on 3/31/23.
//

import SwiftUI

struct LocationView: View {
    @State var LocationList: [LocationModel]
    
    init(locationList: [LocationModel]) {
        LocationList = locationList
    }
    
    var body: some View {
        VStack {
            Text("Locations")
            List() {
                ForEach(LocationList, id: \.id) { loc in
                    Text(formatLocation(loc: loc))
                }
            }
        }
        
    }
    private func formatLocation(loc: LocationModel) -> String {
        return "Speed: " + convertSpeed(speed: loc.speed) + " Coords: " + loc.latitude.formatted() + ", " + loc.longitude.formatted()
    }
    private func convertSpeed(speed: Double) -> String {
        return (26.8224 / speed).formatted()
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(locationList: DummyData().locationList)
    }
}
