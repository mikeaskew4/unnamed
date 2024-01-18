//
//  ContentView.swift
//  unnamed
//
//  Created by Mike Askew on 12/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var orientation = UIDeviceOrientation.unknown

    @ObservedObject var sharedData = SharedRadiusData()
    @ObservedObject var tabsModel = TabsModel()
    
    @State private var firstTab = [Tab(id: UUID(), title: "Radius1", radius: 50)]
    @State private var selectedTab: Tab?

    @State private var isTabListViewVisible: Bool = true

    init() {
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
            if orientation.isLandscape {
                // Landscape layout
                HStack {
                    
                    VStack {
                        if isTabListViewVisible {
                            VStack {
                                TabListView(tabsModel: tabsModel, selectedTab: $selectedTab, sharedData: sharedData)
                                .padding(.vertical, 0)
                            
                                CustomizeView(tabsModel: tabsModel, selectedTab: selectedTabBinding, sharedData: sharedData)
                                    .padding(20)
                                    .background(.black)

                                Button("Reset") {
                                    resetAll()
                                }
                            }
                        }
                        
                    }
                    .background(.black)
                    .zIndex(2)
                    CircleView(tabsModel: tabsModel, sharedData: sharedData)
                        .clipped() // Prevent content from spilling out

                        .zIndex(0)
                }

            } else {
                // Portrait layout
                VStack {
                    
                    CircleView(tabsModel: tabsModel, sharedData: sharedData)
                        .zIndex(0)
                        .clipped() // Prevent content from spilling out

                    VStack {
                        
                        if isTabListViewVisible {
                            VStack {
                                TabListView(tabsModel: tabsModel, selectedTab: $selectedTab, sharedData: sharedData)
                                .padding(.vertical, 0)
                            
                                CustomizeView(tabsModel: tabsModel, selectedTab: selectedTabBinding, sharedData: sharedData)
                                    .padding(20)
                                    .background(.black)
                                Button("Reset") {
                                    resetAll()
                                }
                            }
                        }
                    }
                }
                .background(.black)
                .zIndex(2)
            }
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }


    func moveTab(from source: IndexSet, to destination: Int) {
        tabsModel.moveTab(from: source, to: destination)
    }

    func deleteTab(at offsets: IndexSet) {
        tabsModel.deleteTab(at: offsets)
    }
    
    func resetAll() {
        // Reset models
        sharedData.reset()
        tabsModel.reset()

        // Reset local state
        selectedTab = nil
        isTabListViewVisible = true

        // Add initial tab again if needed
        let initialTab = Tab(id: UUID(), title: "Radius1", radius: 50)
        tabsModel.tabs.append(initialTab)
        selectedTab = initialTab
    }
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

#Preview {
    ContentView()
}
