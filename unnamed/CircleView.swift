//
//  CircleView.swift
//  unnamed
//
//  Created by Mike Askew on 12/12/23.
//

import Foundation
import SwiftUI

struct Tab: Identifiable, Equatable {
    var id: UUID
    var title: String
    var color: Color
    var radius: CGFloat = 50
    
    static func ==(lhs: Tab, rhs: Tab) -> Bool {
        lhs.id == rhs.id
    }

    init(id: UUID = UUID(), title: String, color: Color = Color.random, radius: CGFloat) {
        self.id = id
        self.title = title
        self.color = color
        self.radius = radius
    }
    
    mutating func updateRadius(from sharedData: SharedRadiusData) {
        if self.id == sharedData.radiusId {
            print("updating")
            print(self.title, self.radius)
            self.radius = sharedData.radius
            print(self.title, self.radius)
        }
    }
}

struct CircleView: View {
    @ObservedObject var tabsModel: TabsModel
    @ObservedObject var sharedData: SharedRadiusData

//    var updatedTabs: [Tab] {
//        tabs.map { var tab = $0
//            tab.updateRadius(from: sharedData)
//            return tab
//        }
//    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                ForEach(tabsModel.tabs) { tab in
                    Circle()
                        .stroke(tab.color, lineWidth: 3)
                        .frame(
                            width: tab.radius,
                            height: tab.radius
                        )
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
        }
    }
}

extension Color {
    static var random: Color {
        return Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
    }
}
