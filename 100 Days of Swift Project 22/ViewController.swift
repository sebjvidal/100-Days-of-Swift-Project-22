//
//  ViewController.swift
//  100 Days of Swift Project 22
//
//  Created by Seb Vidal on 05/01/2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var alertShown = false

    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var identifierLabel: UILabel!
    @IBOutlet var circleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        setupLocationManager()
        setupCircleView()
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    func setupCircleView() {
        circleView.clipsToBounds = true
        circleView.layer.cornerCurve = .circular
        circleView.layer.cornerRadius = 128
        circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity, for: beacon)
        } else {
            update(distance: .unknown)
        }
    }
    
    func startScanning() {
        let uuid1 = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let uuid2 = UUID(uuidString: "DB937B37-6CD4-4B6C-AC27-C6614054EEC4")!
        let uuid3 = UUID(uuidString: "76D4D946-01C3-4C55-978A-B31C89297A02")!
        
        let beaconRegion1 = CLBeaconRegion(proximityUUID: uuid1, major: 123, minor: 456, identifier: "First Beacon")
        let beaconRegion2 = CLBeaconRegion(proximityUUID: uuid2, major: 123, minor: 456, identifier: "Second Beacon")
        let beaconRegion3 = CLBeaconRegion(proximityUUID: uuid3, major: 123, minor: 456, identifier: "Third Beacon")
        
        locationManager?.startMonitoring(for: beaconRegion1)
        locationManager?.startRangingBeacons(in: beaconRegion1)
        
        locationManager?.startMonitoring(for: beaconRegion2)
        locationManager?.startRangingBeacons(in: beaconRegion2)
        
        locationManager?.startMonitoring(for: beaconRegion3)
        locationManager?.startRangingBeacons(in: beaconRegion3)
    }
    
    func update(distance: CLProximity, for beacon: CLBeacon? = nil) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceLabel.text = "Far"
                self.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceLabel.text = "Near"
                self.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceLabel.text = "Right Here"
                self.circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceLabel.text = "Unknown"
                self.circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
        }
        
        if let beacon = beacon {
            identifierLabel.text = beacon.uuid.uuidString
        } else {
            identifierLabel.text = ""
        }
    }
    
    func showAlert(for beacon: CLBeacon) {
        if !alertShown {
            let title = "Beacon Found"
            let message = "Beacon with a UUID of \(beacon.uuid.uuidString) in range!"
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            
            alertShown = true
            
            present(alertController, animated: true)
        }
    }

}

