//
//  SharedRadiusData.swift
//  unnamed
//
//  Created by Mike Askew on 12/13/23.
//

import Foundation

class SharedRadiusData: ObservableObject {
    @Published var radiusId: UUID = UUID()
    @Published var radius: CGFloat = 50
    @Published var blur: CGFloat = 0
    @Published var stroke: CGFloat = 3
    @Published var divisions: Int = 0  // Use Int for divisions

    func reset() {
        radiusId = UUID()  // Reset to a new UUID
        radius = 50       // Reset to initial radius
        blur = 0          // Reset blur to zero
        stroke = 3        // Reset stroke to initial value
        divisions = 0    // Reset divisions to initial value
    }
}
