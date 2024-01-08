//
//  RadiusSliderView.swift
//  unnamed
//
//  Created by Mike Askew on 1/8/24.
//

import Foundation
import SwiftUI

struct RadiusSliderView: View {
    @ObservedObject var sharedData: SharedRadiusData
    @ObservedObject var tabsModel: TabsModel
    var selectedTab: Tab
    
    @Binding var value: Double

    @State var lastCoordinateValue: CGFloat = 0.0
    var sliderRange: ClosedRange<Double> = 1...250
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(width: geometry.size.width * 0.8, height: 4)
                        .padding(.top, 2)
                        .padding(.bottom, 10)
                    Rectangle()
                        .foregroundColor(Color.red)
                        .frame(width: geometry.size.width * 0.2, height: 4)
                        .padding(.top, 2)
                        .padding(.bottom, 10)
                }
                Slider(value: Binding(
                    get: {self.linearizedValue(for: CGFloat(sharedData.radius))},
                    set: { newValue in
                        sharedData.radius = self.exponentialValue(for: CGFloat(newValue))
                        tabsModel.updateRadius(forTabWithId: selectedTab.id, to: self.exponentialValue(for: CGFloat(newValue)))

                    }
                ), in: sliderRange)
                .accentColor(.clear)
            }
            .onAppear {
                let thumbImage = UIImage(named: "Drag_Button")
                UISlider.appearance().setThumbImage(thumbImage, for: .normal)
                
            }
        }
    }
    
    private func exponentialValue(for value: CGFloat) -> CGFloat {
        if value > 200 {
            return 200 + pow(value - 200, 2)
        } else {
            return value
        }
    }

    private func linearizedValue(for value: CGFloat) -> CGFloat {
        if value > 200 {
            return 200 + sqrt(value - 200)
        } else {
            return value
        }
    }
}
