//
//  MindEaseMapViewRepresentable.swift
//  FinalProject
//
//  Created by Jerry Reddy on 16/04/24.
//
import SwiftUI
import MapKit

struct MindEaseMapViewRepresentable: UIViewRepresentable {
    let mapView = MKMapView()
    @Binding var mapState: MapViewState
   // @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
            context.coordinator.addDoctorsToMap(homeViewModel.doctors)
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = homeViewModel.selectedMindEaseLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
            }
            break
        case .polylineAdded:
            break
        case .bookAccepted:
            guard let book = homeViewModel.book else {return}
            guard let doctors = homeViewModel.currentUser, doctors.accountType == .doctor else {return}
            guard let route = homeViewModel.routeToPickupLocation else {return}
            context.coordinator.configurePolylineToPickupLocation(withRoute: route)
            context.coordinator.addAndSelectAnnotation(withCoordinate: book.pickupLocation.toCoordinate())
        default:
            break
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension MindEaseMapViewRepresentable {
    class MapCoordinator: NSObject, MKMapViewDelegate {
        var parent: MindEaseMapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        init(parent: MindEaseMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
            
            if let annotation = annotation as? DoctorAnnotation {
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "doctor")
                view.image = UIImage(named: "chevron")
                return view
            }
            return nil
        }
        
        func configurePolylineToPickupLocation(withRoute route: MKRoute) {
            self.parent.mapView.addOverlay(route.polyline)
           let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                          edgePadding: .init(top: 88, left: 32, bottom: 360, right: 32))
            
            self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapView.addAnnotation(anno)
            parent.mapView.selectAnnotation(anno, animated: true)
            
        }
        
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocationCoordinate else { return }
            parent.homeViewModel.getDestinationRoute(from: userLocationCoordinate, to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded
               let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                              edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
       
        func clearMapViewAndRecenterOnUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
        func addDoctorsToMap(_ doctors: [User]) {
            let annotations = doctors.map({ DoctorAnnotation(doctor: $0) })
            for annotation in annotations {
                self.parent.mapView.addAnnotation(annotation)
            }
        }

    //        for doctor in doctors {
     //          let doctorAnno = DoctorAnnotation(doctor: doctor)
                
     //       }
        
    }
}
