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


    var body: some View {
        ScrollView {
            VStack {
                if let selectedTab = selectedTab {
                    Spacer()
                    HStack {
                        Text("Radius")
                            .frame(alignment: .leading)
                        Slider(value: Binding(
                            get: { Double(sharedData.radius) },
                            set: { newValue in
                                sharedData.radius = CGFloat(newValue)
                                tabsModel.updateRadius(forTabWithId: selectedTab.id, to: CGFloat(newValue))
                            }
                        ), in: 1...500)
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
