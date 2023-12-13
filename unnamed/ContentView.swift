//
//  ContentView.swift
//  unnamed
//
//  Created by Mike Askew on 12/12/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ObservedObject var sharedData = SharedRadiusData()
    @ObservedObject var tabsModel = TabsModel()
    
    @State private var firstTab = [Tab(id: UUID(), title: "Radius1", radius: 50)]
    @State private var selectedTab: Tab?

    @State private var isTabListViewVisible: Bool = true

    init() {
//        tabsModel.tabs.append(firstTab)
        tabsModel.tabs.append(contentsOf: [Tab(id: UUID(), title: "Radius1", radius: 50)])
        _selectedTab = State(initialValue: tabsModel.tabs.first)

    }
    
    private var selectedTabBinding: Binding<Tab?> {
        Binding(
            get: { self.selectedTab },
            set: { self.selectedTab = $0 }
        )
    }
    
    var body: some View {
        
        Group {
            if horizontalSizeClass == .compact {
                // Portrait layout
                VStack {
                    CircleView(tabsModel: tabsModel, sharedData: sharedData)

                    if isTabListViewVisible {
                        VStack {
                            TabListView(tabsModel: tabsModel, selectedTab: $selectedTab, sharedData: sharedData)
                                .padding(.vertical, 0)
                            CustomizeView(tabsModel: tabsModel, selectedTab: selectedTabBinding, sharedData: sharedData)
                                .padding(20)
                        }
                        
                    }

                }
            } else {
                // Landscape layout
                VStack {
                    CircleView(tabsModel: tabsModel, sharedData: sharedData)

                    if isTabListViewVisible {
                        VStack {
                            TabListView(tabsModel: tabsModel, selectedTab: $selectedTab, sharedData: sharedData)
                                .padding(.vertical, 0)
                            CustomizeView(tabsModel: tabsModel, selectedTab: selectedTabBinding, sharedData: sharedData)
                                .padding(20)
                        }
                    }

                }
            }
        }
        .navigationTitle("Content View")
    }


    func moveTab(from source: IndexSet, to destination: Int) {
        tabsModel.moveTab(from: source, to: destination)
    }

    func deleteTab(at offsets: IndexSet) {
        tabsModel.deleteTab(at: offsets)
    }
}


#Preview {
    ContentView()
}
