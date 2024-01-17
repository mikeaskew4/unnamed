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
    case none
}

struct StyledGauge: View {
    @ObservedObject var sharedData: SharedRadiusData
    @ObservedObject var tabsModel: TabsModel
    var selectedTab: Tab
    var range: ClosedRange<CGFloat>
    var type: GaugeType
    var title: String? = ""
    
    var body: some View {
        if #available(iOS 16, *) {
            VStack {
                Text(Int(gaugeValue.rounded()).description)
                Gauge(value: gaugeValue, in: range) {
                    Text("")
                } currentValueLabel: {
                    Text(Int(gaugeValue.rounded()).description)
                }
                .gaugeStyle(.accessoryCircularCapacity)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let dragAmount = value.translation.height
                            let sensitivityFactor: CGFloat = 50.0
                            let change = -dragAmount / sensitivityFactor
                            let newValue = min(max(gaugeValue + change, range.lowerBound), range.upperBound)
                            if type == .divisions {
                                updateSharedData(with: Int(newValue))
                            } else {
                                updateSharedData(with: newValue)
                            }
                        }
                )
                Text(Int(gaugeValue.rounded()).description)
                Text(title ?? "")
            }
        }
        else {
            Slider(value: Binding(
                get: { gaugeValue },
                set: { newValue in
                    updateSharedData(with: newValue)
                }
            ), in: range)
        }
    }
    
    private var gaugeValue: CGFloat {
        switch type {
        case .stroke:
            return sharedData.stroke
        case .divisions:
            return CGFloat(sharedData.divisions)
        case .blur:
            return sharedData.blur
        default:
            return 0.0
        }
    }
    
    private func updateSharedData(with newValue: CGFloat) {
        switch type {
        case .stroke:
            sharedData.stroke = newValue
            tabsModel.updateStroke(forTabWithId: selectedTab.id, to: newValue)
        case .blur:
            sharedData.blur = newValue
            tabsModel.updateBlur(forTabWithId: selectedTab.id, to: newValue)
        default:
            break
        }
    }
    
    private func updateSharedData(with newValue: Int) {
        switch type {
        case .divisions:
            // @@TODO handle under 2 divisions
            sharedData.divisions = newValue
            tabsModel.updateDivisions(forTabWithId: selectedTab.id, to: newValue)
        default:
            break
        }
    }
}

#Preview {
    ContentView()
}
