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
    case blur
    case divisions
    case gap
    case rotation
    case none
}

struct StyledGauge: View {
    @ObservedObject var sharedData: SharedRadiusData
    @ObservedObject var tabsModel: TabsModel
    var selectedTab: Tab
    var range: ClosedRange<CGFloat>
    var type: GaugeType
    var title: String? = ""
    
    @State private var gaugeFrame: CGRect = .zero
    @State private var topVisible: Bool = false
    @State private var bottomVisible: Bool = false
    
    var gHeight: CGFloat = 140
    var gWidth: CGFloat = 100
    
    
    var body: some View {
        if #available(iOS 16, *) {
            VStack(alignment: .center) {
                Spacer()
                Rectangle()
                    .fill(.clear)
                    .border(.clear, width: 2.0)
                    .frame(width: gWidth, height: gHeight)
                    .overlay(
                        VStack {
                            ZStack {
                                Text(Int(gaugeValue.rounded()).description)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .padding(.vertical, 8)
                            .opacity(topVisible ? 1.0 : 0)
                            
                            Gauge(value: gaugeValue, in: range) {
                                Text("")
                            } currentValueLabel: {
                                Text(Int(gaugeValue.rounded()).description)
                                    .opacity(bottomVisible || topVisible ? 0 : 1.0)
                            }
                            .gaugeStyle(.accessoryCircularCapacity)
                            .scaleEffect(UIDevice.current.userInterfaceIdiom == .pad ? 1.375 : 1.0)

                            Text(Int(gaugeValue.rounded()).description)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 8)
                                .opacity(bottomVisible ? 1.0 : 0)
                            
                            Text(title ?? "")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
//                                if value.location.y > -16 && value.location.y < gHeight {
//                                    updateGaugeValue(with: value)
//                                }
                                updateGaugeValue(with: value)
                                
                                if (value.location.y > (gHeight / 2)) {
                                    topVisible = true
                                    bottomVisible = false
                                }
                                if (value.location.y < (gHeight / 2)) {
                                    topVisible = false
                                    bottomVisible = true
                                }
                            }
                            .onEnded { _ in
                                topVisible = false
                                bottomVisible = false
                            }
                    )
                )
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .frame(minHeight: 140)

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
        case .blur:
            return sharedData.blur
        case .divisions:
            return CGFloat(sharedData.divisions)
        case .gap:
            return CGFloat(sharedData.gap)
        case .rotation:
            return CGFloat(sharedData.rotation)
        default:
            return 0.0
        }
    }
    
    private func updateGaugeValue(with value: DragGesture.Value) {
        let dragAmount = value.translation.height
        let sensitivityFactor: CGFloat = 64.0
        let change = -dragAmount / sensitivityFactor
        let newValue = min(max(gaugeValue + change, range.lowerBound), range.upperBound)
//        if isWithinBounds(point: value.location) {
            if type == .divisions {
                updateSharedData(with: Int(newValue))
            } else if type == .gap {
                if sharedData.divisions > 1 {
                    updateSharedData(with: newValue)
                }
            } else {
                updateSharedData(with: newValue)
            }
//        }
    }

    private func updateSharedData(with newValue: CGFloat) {
        switch type {
        case .stroke:
            sharedData.stroke = newValue
            tabsModel.updateStroke(forTabWithId: selectedTab.id, to: newValue)
        case .blur:
            sharedData.blur = newValue
            tabsModel.updateBlur(forTabWithId: selectedTab.id, to: newValue)
        case .gap:
            sharedData.gap = newValue
            tabsModel.updateGap(forTabWithId: selectedTab.id, to: newValue)
        case .rotation:
            sharedData.rotation = newValue
            tabsModel.updateRotation(forTabWithId: selectedTab.id, to: newValue)
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
