//
//  UserProfileViewModel.swift
//  GithubClone
//
//  Created by Manikandan Arumugam on 17/07/25.
//

import SwiftUI
import Observation
import Foundation

class UserProfileViewModel: ObservableObject {
    @Published var userDetail: GitHubUserDetail?
    @Published var isLoading = false
    
    func fetchUserDetail(username: String, alertViewModel: AlertViewModel) {
        guard let url = URL(string: "https://api.github.com/users/\(username)") else {
            alertViewModel.displayAlert(message: "Invalid URL")
            return
        }
        
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    alertViewModel.displayAlert(message: error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    alertViewModel.displayAlert(message: "No data received from server.")
                    return
                }
                
                do {
                    let detail = try JSONDecoder().decode(GitHubUserDetail.self, from: data)
                    self.userDetail = detail
                } catch {
                    alertViewModel.displayAlert(message: "Failed to decode user details.")
                    print("Error decoding user detail JSON: \(error)")
                }
            }
        }.resume()
    }
    
    func fetchUserRepositories(username: String, completion: @escaping ([GitHubRepo]) -> Void) {
        let urlString = "https://api.github.com/users/\(username)/repos?sort=stars&per_page=20"
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let repos = try JSONDecoder().decode([GitHubRepo].self, from: data)
                DispatchQueue.main.async {
                    completion(repos)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }
}
