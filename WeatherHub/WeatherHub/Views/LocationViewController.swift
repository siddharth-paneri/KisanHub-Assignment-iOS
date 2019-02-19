//
//  LocationViewController.swift
//  WeatherHub
//
//  Created by Siddharth Paneri on 19/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var selectedLocation: Location = .uk
    var locations: [Location] = [.uk, .england, .scotland, .wales]
    
    private let locationDataController = LocationDataController()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        //TODO:-
        /** This is just temp code for storing locations in DB, so if we receive it from an API we can store in database */
        locationDataController.store(locations: locations)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Locations"
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == Segue.weatherData.rawValue {
            let destinationVC = segue.destination as? WeatherDataViewController
            destinationVC?.selectedLocation = selectedLocation
        }
    }
 

}

extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        cell.textLabel?.text = locations[indexPath.row].rawValue
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLocation = locations[indexPath.row]
        performSegue(withIdentifier: Segue.weatherData.rawValue, sender: self)
    }
}
