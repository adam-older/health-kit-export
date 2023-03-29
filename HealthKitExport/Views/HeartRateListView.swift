//
//  HeartRateListView.swift
//  HealthKitExport
//
//  Created by Adam Older on 3/23/23.
//

import SwiftUI

struct HeartRateListView: View {
    
    @State var HeartRateList: [HeartRateStat]
    
    init(heartRateList: [HeartRateStat]) {
        HeartRateList = heartRateList
    }
    
    var body: some View {
        VStack {
            Text("Heart Rate")
            List() {
                ForEach(HeartRateList) { list in
                    /*@START_MENU_TOKEN@*/Text(list.HeartRate)/*@END_MENU_TOKEN@*/
                }
            }
        }
        
    }
}

struct HeartRateListView_Previews: PreviewProvider {

    static var previews: some View {
        HeartRateListView(heartRateList: [HeartRateStat(HeartRate: "120"), HeartRateStat(HeartRate: "110"), HeartRateStat(HeartRate: "122")])
    }
}
