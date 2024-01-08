//
//  CustomizeView.swift
//  unnamed
//
//  Created by Mike Askew on 12/12/23.
//

import Foundation
import SwiftUI

struct CustomizeView: View {
    @ObservedObject var tabsModel: TabsModel
    @Binding var selectedTab: Tab?
    @ObservedObject var sharedData: SharedRadiusData
    @State private var tempColor: Color = Color.clear // Temporary state for color

    @State private var currentValue = 0.0
    
    var body: some View {
        ScrollView {
            VStack {
                if let selectedTab = selectedTab {
                    Spacer()
                    
                    // Radius
                    HStack {
//                        Text("Radius")
//                            .frame(alignment: .leading)
                        RadiusSliderView(
                            sharedData: sharedData,
                            tabsModel: tabsModel,
                            selectedTab: selectedTab,
                            value: $currentValue,
                            sliderRange: 1...250
                        )
                        .frame(height: 50)
                    }
                    
                    // Stroke
                    HStack {
                        Text("Size")
                            .frame(alignment: .leading)
                        Slider(value: Binding(
                            get: { Double(sharedData.stroke) },
                            set: { newValue in
                                sharedData.stroke = CGFloat(newValue)
                                tabsModel.updateStroke(forTabWithId: selectedTab.id, to: CGFloat(newValue))
                            }
                        ), in: 0...20)
                    }
                    
                    // Color Picker
                    HStack {
                        Text("Color")
                            .frame(alignment: .leading)
                            .padding(.trailing, 10)
                        ColorPicker("", selection: $tempColor)
                            .labelsHidden() // Hide the default label
                            .onChange(of: tempColor) { newValue in
                                if let index = tabsModel.tabs.firstIndex(where: { $0.id == selectedTab.id }) {
                                    tabsModel.tabs[index].color = newValue
                                }
                            }
                        Spacer()
                    }
                    
                    // Blur
                    HStack {
                        Text("Blur")
                            .frame(alignment: .leading)
                        Slider(value: Binding(
                            get: { Double(sharedData.blur) },
                            set: { newValue in
                                sharedData.blur = CGFloat(newValue)
                                tabsModel.updateBlur(forTabWithId: selectedTab.id, to: CGFloat(newValue))
                            }
                        ), in: 0...10)
                    }
                    
                    // Divisions
                    HStack {
                        Text("Divisions")
                            .frame(alignment: .leading)
                        Slider(value: Binding(
                            get: { Double(sharedData.divisions) },
                            set: { newValue in
                                sharedData.divisions = Int(newValue)
                                tabsModel.updateDivisions(forTabWithId: selectedTab.id, to: Int(newValue))
                            }
                        ), in: 0...20)
                    }
                    
                    Spacer()
                    
                    .onAppear {
                        self.tempColor = selectedTab.color
                    }
                } else {
                    Text("No tab selected")
                }
            }
            .onChange(of: selectedTab) { _ in
                // Update tempColor when selectedTab changes
                if let newSelectedTab = selectedTab {
                    tempColor = newSelectedTab.color
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill all available space
        }
    }
    
}
