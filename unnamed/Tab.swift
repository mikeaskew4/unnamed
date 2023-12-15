//
//  Tab.swift
//  unnamed
//
//  Created by Mike Askew on 12/12/23.
//

import Foundation
import SwiftUI

class TabsModel: ObservableObject {
    @Published var tabs: [Tab] = []
    
    func moveTab(draggingID: UUID, to targetID: UUID) {
        guard let fromIndex = tabs.firstIndex(where: { $0.id == draggingID }),
              let toIndex = tabs.firstIndex(where: { $0.id == targetID }),
              fromIndex != toIndex else { return }

        withAnimation {
            let toFinalIndex = toIndex > fromIndex ? toIndex + 1 : toIndex
            tabs.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toFinalIndex)
        }
    }

    func moveTab(from source: IndexSet, to destination: Int) {
        withAnimation {
            tabs.move(fromOffsets: source, toOffset: destination)
        }
    }
    
    func deleteTab(at offsets: IndexSet) {
        tabs.remove(atOffsets: offsets)
    }
    
    func updateRadius(forTabWithId id: UUID, to radius: CGFloat) {
        if let index = tabs.firstIndex(where: { $0.id == id }) {
            tabs[index].radius = radius
        }
    }
    
    func updateBlur(forTabWithId id: UUID, to blur: CGFloat) {
        if let index = tabs.firstIndex(where: { $0.id == id }) {
            tabs[index].blur = blur
        }
    }
    
    func updateStroke(forTabWithId id: UUID, to stroke: CGFloat) {
        if let index = tabs.firstIndex(where: { $0.id == id }) {
            tabs[index].stroke = stroke
        }
    }
}

struct TabListView: View {
    @ObservedObject var tabsModel: TabsModel
    @Binding var selectedTab: Tab?
    @ObservedObject var sharedData: SharedRadiusData
    @State private var dragging: Tab?
    @State private var shouldScrollToEnd = false // State variable to control scrolling

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(tabsModel.tabs) { tab in
                        Text(tab.title)
                            .padding()
                            .foregroundColor(tab.id == selectedTab?.id ? Color.black : Color.white) // Black text for selected, white for others
                            .background(tab.id == selectedTab?.id ? Color.white : Color.gray) // White background for selected, gray for others
                            .cornerRadius(0)
                            .shadow(color: tab.id == selectedTab?.id ? Color.black.opacity(0.5) : Color.clear, radius: 3, x: 0, y: tab.id == selectedTab?.id ? -2 : 0) // Drop shadow only above for selected tab
                            .onDrag {
                                self.dragging = tab
                                return NSItemProvider(contentsOf: URL(string: "\(tab.id)")!)!
                            }
                            .onDrop(of: [.url], delegate: DropViewDelegate(item: tab, tabsModel: tabsModel, dragging: $dragging))

                            .onTapGesture {
                                self.selectedTab = tab
                                sharedData.radiusId = tab.id
                                sharedData.radius = tab.radius
                            }
                    }

                    Button(
                        action: {
                            let lastTab = tabsModel.tabs.last
                            let lastTabRadius = lastTab?.radius ?? 0
                            let lastTabStroke = lastTab?.stroke ?? 0
                            let lastTabRadiusPlusStroke = lastTabRadius + lastTabStroke
                            
                            let newRadius = lastTabRadiusPlusStroke + 20
                            let newRadiusId = UUID()
                            let newTab = Tab(id: newRadiusId, title: "Radius\(tabsModel.tabs.count + 1)", radius: newRadius)
                            tabsModel.tabs.append(newTab)
                            sharedData.radiusId = newRadiusId // Update sharedData.radiusId with the new UUID
                            shouldScrollToEnd = true
                            self.selectedTab = newTab
                            
                            // Reset SharedRadiusData to default values
                            resetSharedRadiusData(to: newRadius)
                        },
                        label: {
                            Text("Add")
                                .foregroundColor(.white)
                        }
                    )
                    .padding(.horizontal, 20)

                    Rectangle().frame(width: 0, height: 0).id("endMarker") // Invisible marker
                }
            }
            
            .background(Color.gray)
            .padding(0)
            
            .onChange(of: shouldScrollToEnd) { _ in
                if shouldScrollToEnd {
                    withAnimation {
                        proxy.scrollTo("endMarker", anchor: .trailing) // Scroll to the end marker
                    }
                    shouldScrollToEnd = false // Reset the scrolling flag
                }
            }
        }
        .frame(height: 50)
        .padding(0)
        .background(.white)
    }
    
    func resetSharedRadiusData(to newRadius: CGFloat) {
        sharedData.radius = newRadius
        sharedData.blur = 0    // Default blur
        sharedData.stroke = 3  // Default stroke
    }
    
    struct DropViewDelegate: DropDelegate {
        let item: Tab
        var tabsModel: TabsModel
        @Binding var dragging: Tab?


        func performDrop(info: DropInfo) -> Bool {
            dragging = nil
            return true
        }

        func dropEntered(info: DropInfo) {
            guard let dragging = dragging else { return }

            if item != dragging {
                tabsModel.moveTab(draggingID: dragging.id, to: item.id)
            }
        }

        func dropUpdated(info: DropInfo) -> DropProposal? {
            return DropProposal(operation: .move)
        }
    }
}
