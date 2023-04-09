//
//  QuantitySampleView.swift
//  HealthKitExport
//
//  Created by Adam Older on 3/29/23.
//

import SwiftUI

struct QuantitySampleView: View {
    @State var samples: [QuantitySample]
    
    init(Samples: [QuantitySample]) {
        samples = Samples
    }
    var body: some View {
        VStack {
            Text("Heart Rate")
            List() {
                ForEach(samples) { sample in
                    Text(sample.quantity.formatted())
                }
            }
        }
    }
}

struct QuantitySampleView_Previews: PreviewProvider {
    static var previews: some View {
        QuantitySampleView(Samples: DummyData().heartRateSample)
    }
}
