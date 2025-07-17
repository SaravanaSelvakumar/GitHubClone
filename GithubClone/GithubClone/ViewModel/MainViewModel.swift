//
//  Main.swift
//  GithubClone

//  Created by APPLE on 02/05/25.
//

import SwiftUI
import Observation
import Foundation



class MainViewModel: ObservableObject {
    @Published var gitUserData: [GitHubUser] = []
    @Published var userNotFound: Bool = false
    @Published var isLoading: Bool = false
    @Published var isSearching: Bool = false
    @Published var isLastPage: Bool = false
    @Published var currentPage: Int = 1
    @Published var shouldFetchNextPage: Bool = true
    @Published var lastFetchedCount: Int = 0
    let perPage: Int = 10
    
    
    func fetchTopGitHubUsers(alertViewModel: AlertViewModel, isInitialLoad: Bool = false) {
        guard !isLoading, !isLastPage else { return }
        
        if isInitialLoad {
            currentPage = 1
            gitUserData.removeAll()
            isLastPage = false
            lastFetchedCount = 0
        }
        isLoading = true
        shouldFetchNextPage = false
        isSearching = false
        let urlString = "https://api.github.com/search/users?q=followers:>1000&per_page=\(perPage)&page=\(currentPage)&sort=followers&order=desc"
        
        guard let url = URL(string: urlString) else {
            alertViewModel.displayAlert(message: "Invalid URL.")
            isLoading = false
            shouldFetchNextPage = true
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    alertViewModel.displayAlert(message: error.localizedDescription)
                    self.shouldFetchNextPage = true
                    return
                }
                
                guard let data = data else {
                    alertViewModel.displayAlert(message: "No data received from server.")
                    self.shouldFetchNextPage = true
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SearchResult.self, from: data)
                    self.userNotFound = false
                    if result.items.isEmpty {
                        self.isLastPage = true
                    } else {
                        self.gitUserData += result.items
                        self.currentPage += 1
                        self.lastFetchedCount = self.gitUserData.count
                    }
                } catch {
                    self.isLastPage = true
                    if let apiError = try? JSONDecoder().decode(GitHubErrorResponse.self, from: data) {
                        alertViewModel.displayAlert(message: apiError.message)
                    } else {
                        alertViewModel.displayAlert(message: "Failed to decode GitHub data.")
                    }
                }
                self.shouldFetchNextPage = true
            }
        }.resume()
    }
    
    func searchGitHubUser(username: String, alertViewModel: AlertViewModel) {
        guard !username.isEmpty else { return }
        
        isLoading = true
        let urlString = "https://api.github.com/users/\(username.lowercased())"
        guard let url = URL(string: urlString) else {
            alertViewModel.displayAlert(message: "Invalid search URL.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    alertViewModel.displayAlert(message: error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    alertViewModel.displayAlert(message: "No data received.")
                    return
                }
                
                do {
                    let user = try JSONDecoder().decode(GitHubUser.self, from: data)
                    self.gitUserData = [user]
                    self.userNotFound = false
                    self.isSearching = true
                } catch {
                    alertViewModel.displayAlert(message: "User not found")
                    self.gitUserData = []
                    self.userNotFound = true
                }
            }
        }.resume()
    }
    
    func resetData(alertViewModel: AlertViewModel) {
        currentPage = 1
        isLastPage = false
        gitUserData.removeAll()
        lastFetchedCount = 0
        isSearching = false
        fetchTopGitHubUsers(alertViewModel: alertViewModel, isInitialLoad: true)
    }
    
}
