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
                                    .background(.white)
                            }
                        }
                        
                    }
                    CircleView(tabsModel: tabsModel, sharedData: sharedData)
                }

            } else {
                // Portrait layout
                VStack {
                    
                    CircleView(tabsModel: tabsModel, sharedData: sharedData)
                    VStack {
                        
                        if isTabListViewVisible {
                            VStack {
                                TabListView(tabsModel: tabsModel, selectedTab: $selectedTab, sharedData: sharedData)
                                    .padding(.vertical, 0)
                                CustomizeView(tabsModel: tabsModel, selectedTab: selectedTabBinding, sharedData: sharedData)
                                    .padding(20)
                                    .background(.white)
                            }
                            
                        }
                        
                    }
                }
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
