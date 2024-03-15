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
    
    var gHeight: CGFloat = 100
    var gWidth: CGFloat = 72
    
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
                                VStack {
                                    // Color
                                    HStack {
                                        VStack {
                                            ColorPicker("", selection: $tempColor)
                                                .labelsHidden() // Hide the default label
                                                .onChange(of: tempColor) { newValue in
                                                    if let index = tabsModel.tabs.firstIndex(where: { $0.id == selectedTab.id }) {
                                                        tabsModel.tabs[index].color = newValue
                                                    }
                                                }
                                                
                                                .frame(width: gWidth, height: gHeight)
                                                .scaleEffect(UIDevice.current.userInterfaceIdiom == .pad ? 2.25 : 1.375)
                                                .padding(0)
                                            Text("Color")
                                        }
                                        .padding(0)
                                        Spacer()
                                    }
                                    .padding(0)
                                    
                                    // Shape
                                    HStack() {
                                        // Stroke
                                        StyledGauge(
                                            sharedData: sharedData,
                                            tabsModel: tabsModel,
                                            selectedTab: selectedTab,
                                            range: 1...100,
                                            type: .stroke,
                                            title: "Size"
                                        )
                                        Spacer()
                                        
                                        // Blur
                                        StyledGauge(
                                            sharedData: sharedData,
                                            tabsModel: tabsModel,
                                            selectedTab: selectedTab,
                                            range: 0...24,
                                            type: .blur,
                                            title: "Blur"
                                        )
                                        Spacer()
                                        
                                        // Divisions
                                        StyledGauge(
                                            sharedData: sharedData,
                                            tabsModel: tabsModel,
                                            selectedTab: selectedTab,
                                            range: 1...32,
                                            type: .divisions,
                                            title: "Steps"
                                        )
                                        Spacer()
                                        
                                        // Gap
                                        StyledGauge(
                                            sharedData: sharedData,
                                            tabsModel: tabsModel,
                                            selectedTab: selectedTab,
                                            range: 1...CGFloat((360 / sharedData.divisions) - 1), // subtract 1 so the division doesn't completely disappear
                                            type: .gap,
                                            title: "Gap"
                                        )
                                        Spacer()
                                        
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
                                    .padding(0)
                                }
                                .padding(0)
                                .frame(maxWidth: .infinity)
                            )
                        default:
                            return AnyView(Text("Default Content for Index \(index)"))
                        }
                    }, expandedItemIndex: $expandedItemIndex)
                    .padding(0)
                    
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
            .padding(0)
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
        .padding(0)
        .frame(height: 800)
        
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


// Add this at the end of your CustomizeView.swift file
struct CustomizeView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
}
