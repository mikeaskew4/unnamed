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
    var stroke: CGFloat = 3
    var blur: CGFloat = 0
    var divisions: Int = 0
    
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
    
    mutating func updateBlur(from sharedData: SharedRadiusData) {
        if self.id == sharedData.radiusId {
            self.blur = sharedData.blur
        }
    }
    
    mutating func updateStroke(from sharedData: SharedRadiusData) {
        if self.id == sharedData.radiusId {
            self.stroke = sharedData.stroke
        }
    }
    
    mutating func updateDivisions(from sharedData: SharedRadiusData) {
        if self.id == sharedData.radiusId {
            self.divisions = sharedData.divisions
        }
    }
}

struct CircleView: View {
    @ObservedObject var tabsModel: TabsModel
    @ObservedObject var sharedData: SharedRadiusData

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                ForEach(tabsModel.tabs) { tab in
                    if tab.divisions < 2 {
                        // Draw a full circle
                        Circle()
                            .stroke(tab.color, lineWidth: tab.stroke)
                            .blur(radius: tab.blur)
                            .frame(width: tab.radius * 2, height: tab.radius * 2)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    } else {
                        // Draw divided circle
                        ForEach(0..<Int(tab.divisions), id: \.self) { index in
                            let totalAngle = 360.0
                            let anglePerDivision = totalAngle / Double(tab.divisions)
                            let startAngle = anglePerDivision * Double(index) - 90 // Subtract 90 to start from top
                            let endAngle = startAngle + anglePerDivision
                            let gap = 2.0 // Gap between segments in degrees

                            Path { path in
                                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                let radius = tab.radius - tab.stroke / 2 // Adjusting for stroke width @@TODO fix this -- dividing by 4 is closer
                                path.addArc(center: center, radius: radius, startAngle: Angle(degrees: startAngle + gap / 2), endAngle: Angle(degrees: endAngle - gap / 2), clockwise: false)
                            }
                            .stroke(tab.color, lineWidth: tab.stroke)
                            .blur(radius: tab.blur)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
    }
}

struct CircleSegment: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)

        return path
    }
}

extension Color {
    static var random: Color {
        return Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
    }
}
