
import SwiftUI
import Combine

class AlertViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var alertTitle: String = ""
    
    func displayAlert(title: String = "Alert", message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
