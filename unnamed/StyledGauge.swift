//
//  StyledGauge.swift
//  unnamed
//
//  Created by Mike Askew on 1/8/24.
//

import Foundation
import SwiftUI

enum GaugeType {
    case stroke
    case divisions
    case blur
}

struct StyledGauge: View {
    @ObservedObject var sharedData: SharedRadiusData
    @ObservedObject var tabsModel: TabsModel
    var selectedTab: Tab
    var range: ClosedRange<CGFloat>
    var type: GaugeType
    
    var body: some View {
        if #available(iOS 16, *) {
            Gauge(value: gaugeValue, in: range) {
                Text("Value")
            } currentValueLabel: {
                Text(Int(gaugeValue.rounded()).description)
            }
            .gaugeStyle(.accessoryCircularCapacity)
        }
//        else
        Slider(value: Binding(
            get: { gaugeValue },
            set: { newValue in
                updateSharedData(with: newValue)
            }
        ), in: range)
//        }
    }
    
    private var gaugeValue: CGFloat {
        switch type {
        case .stroke:
            return sharedData.stroke
        case .divisions:
            return CGFloat(sharedData.divisions)
        case .blur:
            return sharedData.blur
        }
    }
    
    private func updateSharedData(with newValue: CGFloat) {
        switch type {
        case .stroke:
            sharedData.stroke = newValue
            tabsModel.updateStroke(forTabWithId: selectedTab.id, to: newValue)
        case .divisions:
            let newDivisions = Int(newValue)
            sharedData.divisions = newDivisions
            tabsModel.updateDivisions(forTabWithId: selectedTab.id, to: newDivisions)
        case .blur:
            sharedData.blur = newValue
            tabsModel.updateBlur(forTabWithId: selectedTab.id, to: newValue)
        }
    }
}
