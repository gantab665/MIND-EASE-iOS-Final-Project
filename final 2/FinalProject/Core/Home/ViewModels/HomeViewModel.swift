//
//  HomeViewModel.swift
//  FinalProject
//
//  Created by Jerry Reddy on 19/04/24.
//
import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import Combine
import MapKit

class HomeViewModel: NSObject, ObservableObject {
    
    // Mark: - Properties
    
    @Published var doctors = [User]()
    @Published var book: Book?
    private let service = UserService.shared
    private var cancellables = Set<AnyCancellable>()
    var currentUser: User?
    var routeToPickupLocation: MKRoute?
    
    // Location search properties
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedMindEaseLocation: MindEaseLocation?
    @Published var pickupTime: String?
    @Published var dropOffTime: String?
    
    private var searchCompleter = MKLocalSearchCompleter()
    var userLocation: CLLocationCoordinate2D?
    
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    // Mark: - Lifecycle
    
    override init() {
        super.init()
        fetchUser()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    // Mark: - Helpers
    
    var bookCancelledMessage: String {
        guard let user = currentUser, let book = book else { return "" }
        
        if user.accountType == .patient {
            if book.state == .doctorCancelled {
                return "Your Doctor Cancelled this Booking"
                
            } else if book.state == .patientCancelled {
                return "Booking cancelled successfully"
            }
        } else {
            if book.state == .doctorCancelled {
                return "Booking cancelled successfully"

            }
            
            else if book.state == .patientCancelled {
                return "Patient has cancelled the booking"
            }
        }
        return ""
    }


    
    func viewForState(_ state: MapViewState, user: User) -> some View {
        switch state {
        case .polylineAdded, .locationSelected:
            return AnyView(BookRequestView())
        case .bookRequested:
            if user.accountType == .patient {
               return AnyView(BookLoadingView())
            } else {
                if let book = self.book {
                  return AnyView(AcceptBookView(book: book))
                }
            }
        case .bookAccepted:
            if user.accountType == .patient {
                return AnyView(BookAcceptedView())
            } else {
                if let book = self.book {
                    return AnyView(PatientArrivalView(book: book))
                }
            }
        case .bookCancelledByPatient, .bookCancelledByDoctor:
            return AnyView(BookCancelledView())
        default:
            break
            
        }
        
        return AnyView(Text(""))
    }

    // Mark: - User API
  

    func fetchUser() {
        service.$user
            .sink { user in
                self.currentUser = user
                guard let user = user else { return }
            
               
                if user.accountType == .patient {
                    self.fetchDoctors()
                    self.addBookObserverForPatient()
                } else {
                    self.addBookObserverForDoctor()
                }
                
            }
            .store(in: &cancellables)
    }
    private func updateBookState( state: BookState) {
        guard let book = book else {return}
        
        var data = ["state": state.rawValue]
        
        if state == .accepted {
            data["travelTimeToPatient"] = book.travelTimeToPatient
        }
        
        Firestore.firestore().collection("Bookings").document(book.id).updateData(data)
        { _ in
            print("DEBUG: Did update Booking with state \(state)")
        }
    }
    
    func deleteBook() {
        guard let book = book else { return }
        
        Firestore.firestore().collection("Bookings").document(book.id).delete { _ in
            self.book = nil
        }
    }
}

// Mark: - Patient API

extension HomeViewModel {
    
    func addBookObserverForPatient() {
        guard let currentUser = currentUser, currentUser.accountType == .patient else { return }
        
        Firestore.firestore().collection("Bookings")
            .whereField("patientUid", isEqualTo: currentUser.uid)
            .addSnapshotListener { snapshot, _ in
                guard let change = snapshot?.documentChanges.first,
                      change.type == .added
                      || change.type == .modified else {return}
                guard let book = try? change.document.data(as: Book.self) else {return}
                self.book = book
                
                print("DEBUG: Updated Booking state is \(book.state)")
        }
    }
    func fetchDoctors() {
        Firestore.firestore().collection("users")
            .whereField("accountType", isEqualTo: AccountType.doctor.rawValue)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }

                let doctors = documents.compactMap({ try? $0.data(as: User.self) })
                self.doctors = doctors
            }
    }
    func requestBook() {
        guard let doctor = doctors.first else { return }
        guard let currentUser = currentUser else { return }
        guard let dropOffLocation = selectedMindEaseLocation else { return }
        let dropOffGeoPoint = GeoPoint(latitude: dropOffLocation.coordinate.latitude, longitude: dropOffLocation.coordinate.longitude)
        let userLocation = CLLocation(latitude: currentUser.coordinates.latitude, longitude: currentUser.coordinates.longitude)

        getPlacemark(forLocation: userLocation) { placemark, error in
            guard let placemark = placemark else { return }
            
            let bookCost = self.computeRidePrice(forType: .psychiatrist)

            let book = Book(
                            patientUid: currentUser.uid,
                            doctorUid: doctor.uid,
                            patientName: currentUser.fullname,
                            doctorName: doctor.fullname,
                            patientLocation: currentUser.coordinates,
                            doctorLocation: doctor.coordinates,
                            pickupLocationName: placemark.name ?? "Current Location",
                            dropoffLocationName: dropOffLocation.title,
                            pickupLocationAddress: self.addressFromPlacemark(placemark),
                            pickupLocation: currentUser.coordinates,
                            dropoffLocation: dropOffGeoPoint ,
                            bookCost: bookCost,
                            distanceToPatient: 0,
                            travelTimeToPatient: 0,
                            state: .requested)
            
            guard let encodedBook = try? Firestore.Encoder().encode(book) else { return }
            Firestore.firestore().collection("Bookings").document().setData(encodedBook) { _ in
                print("DEBUG: Did upload booking to firestore")
            }
        }
    }
    func cancelBookAsPatient(){
        updateBookState(state: .patientCancelled)
    }
}

// Mark: - Doctor API

extension HomeViewModel {
    
    func addBookObserverForDoctor() {
        guard let currentUser = currentUser, currentUser.accountType == .doctor else { return }
        
        Firestore.firestore().collection("Bookings")
            .whereField("doctorUid", isEqualTo: currentUser.uid)
            .addSnapshotListener { snapshot, _ in
                guard let change = snapshot?.documentChanges.first,
                      change.type == .added
                        || change.type == .modified else {return}
                guard let book = try? change.document.data(as: Book.self) else {return}
                self.book = book
                
                self.getDestinationRoute(from: book.doctorLocation.toCoordinate(),
                                         to: book.pickupLocation.toCoordinate()) {route in
                    self.routeToPickupLocation = route

                    self.book?.travelTimeToPatient = Int(route.expectedTravelTime / 60)
                    self.book?.distanceToPatient = route.distance
                }
            }
    }
 
    
    
    func rejectBook() {
        updateBookState(state: .rejected)
    }
    func acceptBook() {
        updateBookState(state: .accepted)
    }
    func cancelBookAsDoctor(){
        updateBookState(state: .doctorCancelled)
    }
    


}

// Mark: - LocationSearchHelpers
extension HomeViewModel {
    
    func addressFromPlacemark(_ placemark: CLPlacemark) -> String {
        var result = ""
        
        if let thoroughfare = placemark.thoroughfare {
            result += thoroughfare
        }
        if let subthoroughfare = placemark.subThoroughfare {
            result += "\(subthoroughfare)"
        }
        if let subadministrativearea = placemark.subAdministrativeArea {
            result += "\(subadministrativearea)"
        }
        return result
    }
    func getPlacemark(forLocation location: CLLocation, completion: @escaping (CLPlacemark?, Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemark, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let placemark = placemark?.first else { return }
            completion(placemark, nil)
        }
    }

    func selectLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultsViewConfig) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                print("DEBUG: Location search failed with error \(error.localizedDescription)")
                return
            }

            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate

            switch config {
            case .book:
                self.selectedMindEaseLocation = MindEaseLocation(title: localSearch.title, coordinate: coordinate)
            case .saveLocation(let viewModel):
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let savedLocation = SavedLocation(title: localSearch.title, address: localSearch.subtitle, coordinates: GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
                guard let encodedLocation = try? Firestore.Encoder().encode(savedLocation) else { return }
                Firestore.firestore().collection("users").document(uid).updateData([
                    viewModel.databaseKey: encodedLocation
                ])
            }
        }
    }

    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title + " " + localSearch.subtitle
        let search = MKLocalSearch(request: searchRequest)

        search.start(completionHandler: completion)
    }

    func computeRidePrice(forType type: BookType) -> Double {
        guard let destCoordinate = selectedMindEaseLocation?.coordinate,
              let userCoordinate = self.userLocation else {
            print("DEBUG: Coordinates not available.")
            return 0.0  // Return a default value or handle the error differently.
        }

        let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let destination = CLLocation(latitude: destCoordinate.latitude, longitude: destCoordinate.longitude)

        let tripDistanceInMeters = userLocation.distance(from: destination)
        return type.computePrice(for: tripDistanceInMeters)
    }

    func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (MKRoute) -> Void) {
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destination)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                return
            }

            guard let route = response?.routes.first else { return }
            self.configurePickupAndDropOffTimes(with: route.expectedTravelTime)
            completion(route)
        }
    }

    func configurePickupAndDropOffTimes(with expectedTravelTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"

        pickupTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expectedTravelTime)
    }
}

extension HomeViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.results = completer.results
        }
    }
}
