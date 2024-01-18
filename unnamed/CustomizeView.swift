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
    
    @State private var accordionItems = [
        AccordionItem(title: "Modifiers"),
        AccordionItem(title: "Animation"),
        AccordionItem(title: "Background")
    ]
    @State private var expandedItemIndex: Int? = nil
    
    var body: some View {
        
        GeometryReader { geometry in
            if let selectedTab = selectedTab {
                // Radius
                HStack {
                    RadiusSliderViewControllerRepresentable(
                        sharedData: sharedData,
                        tabsModel: tabsModel,
                        selectedTab: selectedTab
                    )
                    .frame(height: 50)
                }
            }
            VStack() {
                if let selectedTab = selectedTab {
                    AccordionView(items: $accordionItems, contentForItem: { index in
                        switch index {
                        case 0:
                            return AnyView(
                                // Color Picker
                                Grid(alignment: .bottom, horizontalSpacing: 4, verticalSpacing: 1) {
                                    // Color
                                    GridRow {
                                        VStack {
                                            ColorPicker("", selection: $tempColor)
                                                .labelsHidden() // Hide the default label
                                                .onChange(of: tempColor) { newValue in
                                                    if let index = tabsModel.tabs.firstIndex(where: { $0.id == selectedTab.id }) {
                                                        tabsModel.tabs[index].color = newValue
                                                    }
                                                }
                                            
                                            Text("Color")
                                            
                                            Spacer()
                                        }
                                    }
                                    
                                    // Shape
                                    GridRow {
                                        // Stroke
                                        StyledGauge(
                                            sharedData: sharedData,
                                            tabsModel: tabsModel,
                                            selectedTab: selectedTab,
                                            range: 1...100,
                                            type: .stroke,
                                            title: "Size"
                                        )
                                        
                                        
                                        
                                        // Blur
                                        StyledGauge(
                                            sharedData: sharedData,
                                            tabsModel: tabsModel,
                                            selectedTab: selectedTab,
                                            range: 0...10,
                                            type: .blur,
                                            title: "Blur"
                                        )
                                        
                                        // Divisions
                                        StyledGauge(
                                            sharedData: sharedData,
                                            tabsModel: tabsModel,
                                            selectedTab: selectedTab,
                                            range: 1...32,
                                            type: .divisions,
                                            title: "Steps"
                                        )
                                        
                                        // Gap
                                        StyledGauge(
                                            sharedData: sharedData,
                                            tabsModel: tabsModel,
                                            selectedTab: selectedTab,
                                            range: 1...CGFloat((360 / sharedData.divisions) - 1), // subtract 1 so the division doesn't completely disappear
                                            type: .gap,
                                            title: "Gap"
                                        )
                                        
                                        // Rotation
                                        StyledGauge(
                                            sharedData: sharedData,
                                            tabsModel: tabsModel,
                                            selectedTab: selectedTab,
                                            range: 0...360,
                                            type: .rotation,
                                            title: "Rotate"
                                        )
                                    }
                                    
                                }
                                .padding()
                                
                            )
                        default:
                            return AnyView(Text("Default Content for Index \(index)"))
                        }
                    }, expandedItemIndex: $expandedItemIndex)
                    
                    .onAppear {
                        self.tempColor = selectedTab.color
                        openFirstAccordionItem()
                    }
                    .onChange(of: selectedTab) { _ in
                        withAnimation {
                            openFirstAccordionItem()
                        }
                    }
                    Spacer()
                } else {
                    Text("No tab selected")
                }
            }
            
            .padding(.top, 50)
            .onChange(of: selectedTab) { _ in
                // Update tempColor when selectedTab changes
                if let newSelectedTab = selectedTab {
                    tempColor = newSelectedTab.color
                }
            }
            Spacer()
            .frame(maxWidth: .infinity, maxHeight: geometry.size.height) // Set the maxHeight to the height of the parent view
        }
        
    }
    private func openFirstAccordionItem() {
        // Collapse all items except the first one
        expandedItemIndex = 0
    }
    
    func gridItems(count: Int) -> [GridItem] {
        var items = [GridItem]()
        
        for index in 0..<count {
            let gridItem: GridItem
            if index == count - 1 && count < 5 {
                // Last item, fill the remaining space
                gridItem = GridItem(.flexible(minimum: UIScreen.main.bounds.width * 0.2, maximum: .infinity))
            } else {
                // Regular item, at least 20% of the row
                gridItem = GridItem(.flexible(minimum: UIScreen.main.bounds.width * 0.2))
            }
            items.append(gridItem)
        }

        return items
    }


}

#Preview {
    ContentView()
}
