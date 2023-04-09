//
//  HeartRateListView.swift
//  HealthKitExport
//
//  Created by Adam Older on 3/23/23.
//

import SwiftUI

struct HeartRateListView: View {
    
    @State var HeartRateSamples: [QuantitySample]
    
    init(heartRateSamples: [QuantitySample]) {
        HeartRateSamples = heartRateSamples
    }
    
    var body: some View {
        VStack {
            Text("Heart Rate")
            List() {
                ForEach(HeartRateSamples) { sample in
                    Text(sample.quantity.formatted())
                }
            }
        }
        
    }
}

struct HeartRateListView_Previews: PreviewProvider {

    static var previews: some View {
        HeartRateListView(heartRateSamples: DummyData().heartRateSample)
    }
}
