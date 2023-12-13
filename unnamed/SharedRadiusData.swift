//
//  SharedRadiusData.swift
//  unnamed
//
//  Created by Mike Askew on 12/13/23.
//

import Foundation

class SharedRadiusData: ObservableObject {
    @Published var radiusId: UUID = UUID()
    @Published var radius: CGFloat = 100
}
