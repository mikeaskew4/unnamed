//
//  RadiusUISliderView.swift
//  unnamed
//
//  Created by Mike Askew on 1/8/24.
//

import Foundation
import UIKit
import SwiftUI

class RadiusSliderViewController: UIViewController {
    @ObservedObject var sharedData: SharedRadiusData
    var tabsModel: TabsModel
    var selectedTab: Tab
    
    private let slider = UISlider()
    private let sliderRange: ClosedRange<Double> = 1...250

    private let defaultTrackView = UIView()
    private let trackSpacerView = UIView()
    private let redTrackView = UIView()
    
    init(sharedData: SharedRadiusData, tabsModel: TabsModel, selectedTab: Tab) {
        self.sharedData = sharedData
        self.tabsModel = tabsModel
        self.selectedTab = selectedTab
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrackViews()
        setupSlider()
    }
    
    private func setupSlider() {
        slider.minimumTrackTintColor = UIColor.clear  // Gray color for the left part of the track
        slider.maximumTrackTintColor = UIColor.clear // Clear color for the right part of the track

        slider.minimumValue = Float(sliderRange.lowerBound)
        slider.maximumValue = Float(sliderRange.upperBound)
        slider.value = Float(linearizedValue(for: CGFloat(sharedData.radius)))

        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        // Customize the slider (e.g., thumb image) here
        let thumbImage = UIImage(named: "Drag_Button")
        slider.setThumbImage(thumbImage, for: .normal)
        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)

        view.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false

        // Set constraints to stretch the slider to the parent view
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: view.topAnchor),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            slider.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func updateSliderValue(tab: Tab, to newValue: Double) {
        selectedTab = tab
        slider.value = Float(linearizedValue(for: CGFloat(newValue)))
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        let newValue = CGFloat(sender.value)
        sharedData.radius = exponentialValue(for: newValue)
        tabsModel.updateRadius(forTabWithId: selectedTab.id, to: exponentialValue(for: newValue))
        
        // Adjust the red track view
        let sliderValue = CGFloat(sender.value)
        if sliderValue > 200 {
            let redTrackWidth = ((sliderValue - 200) / 50) * defaultTrackView.frame.width
            redTrackView.frame.size.width = redTrackWidth
        } else {
            redTrackView.frame.size.width = 0
        }
    }
    
    private func setupTrackViews() {
        view.addSubview(defaultTrackView)
        view.addSubview(trackSpacerView)
        view.addSubview(redTrackView)

        defaultTrackView.backgroundColor = .gray
        trackSpacerView.backgroundColor = .gray
        redTrackView.backgroundColor = .red
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Position the track views
        let sliderTrackHeight: CGFloat = 4
        let yPosition = slider.frame.midY - (sliderTrackHeight / 2)

        // Adjust the default track view
        let defaultTrackWidth = slider.frame.width * 0.8 // Assuming 200 is 80% of the max value
        defaultTrackView.frame = CGRect(x: slider.frame.minX + 12, y: yPosition - 4, width: defaultTrackWidth - 12, height: sliderTrackHeight)

        
        let redTrackStart = defaultTrackWidth
        trackSpacerView.frame = CGRect(x: redTrackStart - 2, y: yPosition - 10, width: 2, height: 16)
        
        // Position the red track view
        
        let redTrackWidth = slider.frame.width - defaultTrackWidth
        redTrackView.frame = CGRect(x: redTrackStart, y: yPosition - 4, width: redTrackWidth - 24, height: sliderTrackHeight)
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
