//
//  WeatherDataViewController.swift
//  WeatherHub
//
//  Created by Siddharth Paneri on 19/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import UIKit
import Charts


class WeatherDataViewController: UIViewController {
    //MARK:-
    @IBOutlet weak var segmentControl_Metric: UISegmentedControl!
    @IBOutlet weak var view_ChartContainer: UIView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //MARK:-
    var selectedMetric: Metric = .temperatureMax
    var selectedLocation: Location = .uk
    var selectedYear: Int16 = 0
    var years: [Int16] = []
    
    private let weatherDataController = WeatherDataController()
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        self.configureChart()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchWeatherData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = self.selectedLocation.rawValue
    }
    
    //MARK:- Charts confuguration and updates
    private func configureChart() {
        print(#function)
//        chartView.delegate = self
        chartView.noDataText = "No data available"
        chartView.noDataTextColor = UIColor.lightGray
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.highlightPerDragEnabled = true
        chartView.legend.enabled = false
        chartView.leftAxis.enabled = true
        chartView.rightAxis.enabled = false
        chartView.chartDescription?.enabled = false
        
        
        let xAxis = chartView.xAxis
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularityEnabled = true
        xAxis.granularity = 0.5
        xAxis.axisMinimum = 1
        xAxis.axisMaximum = 12
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = MonthValueFormatter()
        xAxis.gridColor = UIColor.gray
        xAxis.labelTextColor = UIColor.black
        xAxis.drawLimitLinesBehindDataEnabled = true
        
        let leftAxis = chartView.leftAxis
        leftAxis.granularityEnabled = true
        leftAxis.granularity = 0.5
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.gridColor = UIColor.lightGray
        leftAxis.labelTextColor = UIColor.black
        leftAxis.valueFormatter = TemperatureValueFormatter()
        
        
        let marker = BalloonMarker(color: UIColor.darkGray,
                                   font: .systemFont(ofSize: 12, weight: .bold),
                                   textColor: UIColor.white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        marker.unit = "°"
        chartView.marker = marker
        
    }
    
    /** Call this method to update the historical data when required */
    private func updateChart(_ weatherData: [WeatherDataModel]) {
        print(#function)
        // year selected
        let chartData = weatherData.filter { (item) -> Bool in
            if let year = item.year {
                if years.count > 0 {
                    if year == selectedYear {
                        return true
                    }
                }
            }
            return false
            }.map { (item) -> ChartDataEntry in
                
                if let month = item.month {
                    switch selectedMetric {
                    case .temperatureMax:
                        if let tempMax = item.temperatureMax {
                            return ChartDataEntry(x: Double(month), y: tempMax)
                        }
                        
                    case .temperatureMin:
                        if let tempMin = item.temperatureMin {
                            return ChartDataEntry(x: Double(month), y: tempMin)
                        }
                    case .rainfall:
                        if let rainfall = item.rainfall {
                            return ChartDataEntry(x: Double(month), y: rainfall)
                        }
                        
                    }
                }
                return ChartDataEntry(x: -1.0, y: -1.0)
        }
        
        if chartData.isEmpty {
            chartView.data = nil
            chartView.animate(xAxisDuration: 1)
            return
        }
        
        var colorHex = HEX_WEATHER_BLACK
        switch selectedMetric {
        case .temperatureMax:
            colorHex = HEX_WEATHER_HOT
            
        case .temperatureMin:
            colorHex = HEX_WEATHER_COLD
        case .rainfall:
            colorHex = HEX_WEATHER_RAIN
        }
        
        let color = UIColor(hexString: colorHex)
        let dataSet = LineChartDataSet(values: chartData, label: nil)
        dataSet.axisDependency = .left
        dataSet.setColor(color)
        dataSet.setCircleColor(.white)
        dataSet.lineWidth = 2
        dataSet.circleRadius = 3
        dataSet.fillAlpha = 0.5
        dataSet.fillColor = color//.withAlphaComponent()
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawFilledEnabled = true
        
        let data = LineChartData(dataSets: [dataSet])
        data.setValueTextColor(.black)
        data.setValueFont(UIFont.systemFont(ofSize: 9))
        
        chartView.data = data
        chartView.animate(xAxisDuration: 0.5)
    }
    
    //MARK:- Loaders / HUD
    private func showLoader() {
        segmentControl_Metric.isEnabled = false
        view_ChartContainer.isHidden = true
        activityIndicator.isHidden = false
    }
    
    private func hideLoader() {
        segmentControl_Metric.isEnabled = true
        view_ChartContainer.isHidden = false
        activityIndicator.isHidden = true
    }
    
    //MARK:- Service/ DB interactions
    private func fetchWeatherData() {
        self.showLoader()
        weatherDataController.fetchWeatherData(for: selectedMetric, and: selectedLocation) { [weak self] (weatherData) in
            DispatchQueue.main.async {
                self?.refreshPicker(weatherData)
                self?.refreshUI(weatherData)
                
            }
        }
    }
    
    //MARK:- UI updates
    private func refreshUI(_ weatherData: [WeatherDataModel]) {
        print(#function)
        self.hideLoader()
        self.updateChart(weatherData)
    }
    
    // IBActions
    @IBAction func didSelectSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // max temp
            selectedMetric = .temperatureMax
            if let marker = chartView.marker as? BalloonMarker {
                marker.unit = "°"
            }
        } else if sender.selectedSegmentIndex == 1 {
            // min temp
            selectedMetric = .temperatureMin
            if let marker = chartView.marker as? BalloonMarker {
                marker.unit = "°"
            }
        } else {
            // rainfall
            selectedMetric = .rainfall
            if let marker = chartView.marker as? BalloonMarker {
                marker.unit = "mm"
            }
        }
        fetchWeatherData()
    }
}

//MARK:-
extension WeatherDataViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    /** Used to fetch the stored data directly from DB */
    private func fetchWeatherDataFromDB() {
        let weatherData = weatherDataController.fetchWeatherData(for: selectedLocation, year: selectedYear)
        self.refreshUI(weatherData)
    }
    
    /** Used to refresh the picker values based on selected options */
    func refreshPicker(_ weatherData: [WeatherDataModel]) {
        let yearsTransformed = weatherData.map { (weatherModel) -> Int16 in
            return weatherModel.year!
        }
        years = yearsTransformed.removingDuplicates()
        pickerView.reloadAllComponents()
        if selectedYear == 0 && years.count > 0 {
            pickerView.selectRow(0, inComponent: 0, animated: true)
            selectedYear = years[0]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(years[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if years.count > row {
            selectedYear = years[row]
            self.fetchWeatherDataFromDB()
        }
    }
}


//MARK:-
class MonthValueFormatter: NSObject, IAxisValueFormatter {
    
    private var dateFormatter: DateFormatter
    
    override init() {
        dateFormatter = DateFormatter()
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let monthIndex = Int(value) - 1
        if monthIndex >= 0 && monthIndex < dateFormatter.shortMonthSymbols.count {
            return dateFormatter.shortMonthSymbols[monthIndex]
        }
        return ""
    }
}

//MARK:-
class TemperatureValueFormatter: NSObject, IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(value) + "°"
    }
}
