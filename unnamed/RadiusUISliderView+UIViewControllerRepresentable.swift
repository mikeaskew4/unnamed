//
//  RadiusUISliderView+UIViewControllerRepresentable.swift
//  unnamed
//
//  Created by Mike Askew on 1/8/24.
//

import Foundation
import SwiftUI

// Step 1: UIViewControllerRepresentable Wrapper
struct RadiusSliderViewControllerRepresentable: UIViewControllerRepresentable {
    @ObservedObject var sharedData: SharedRadiusData
    @ObservedObject var tabsModel: TabsModel
    var selectedTab: Tab

    func makeUIViewController(context: Context) -> RadiusSliderViewController {
        return RadiusSliderViewController(sharedData: sharedData, tabsModel: tabsModel, selectedTab: selectedTab)
    }

    func updateUIViewController(_ uiViewController: RadiusSliderViewController, context: Context) {
        // Update the view controller when SwiftUI state changes
        uiViewController.updateSliderValue(tab: selectedTab, to: sharedData.radius)

    }
}
