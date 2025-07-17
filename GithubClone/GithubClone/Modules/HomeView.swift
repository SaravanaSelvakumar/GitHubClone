//
//  HomeView.swift
//  GithubClone
//
//  Created by Manikandan Arumugam on 17/07/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = MainViewModel()
    @EnvironmentObject var alertViewModel: AlertViewModel
    @State private var searchText: String = ""
    @State private var isSearching = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if isSearching {
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            
                            TextField("Search...", text: $searchText)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .foregroundColor(.primary)
                                .onSubmit {
                                    if !searchText.isEmpty {
                                        viewModel.searchGitHubUser(username: searchText, alertViewModel: alertViewModel)
                                    }
                                }
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .padding(.trailing, 35)
                        .background(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(Color(UIColor.systemGray5))
                        )
                        .overlay(
                            HStack {
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        if viewModel.isSearching || viewModel.userNotFound {
                                            viewModel.resetData(alertViewModel: alertViewModel)
                                        }
                                        isSearching = false
                                        searchText = ""
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                                .padding(.trailing, 12)
                            }
                        )
                        .padding(.horizontal)
                    }
                    .padding(.top, 10)
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        if viewModel.userNotFound {
                            Text("User not found")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        } else if viewModel.gitUserData.isEmpty {
                            ProgressView("Loading GitHub Users...")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        } else {
                            GitUserListView(viewModel: viewModel)
                                .environmentObject(alertViewModel)
                            
                        }
                    }
                }
                .refreshable {
                    if viewModel.isSearching || viewModel.userNotFound {
                        viewModel.resetData(alertViewModel: alertViewModel)
                        searchText = ""
                        isSearching = false
                    }
                    searchText = ""
                    isSearching = false
                }
                
            }
            .padding()
            .background(Color(.systemBackground).ignoresSafeArea())
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !isSearching {
                        Button(action: {
                            withAnimation {
                                isSearching = true
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .alert(isPresented: $alertViewModel.showAlert) {
                Alert(title: Text(alertViewModel.alertTitle),
                      message: Text(alertViewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .onAppear {
                if viewModel.gitUserData.isEmpty {
                    viewModel.fetchTopGitHubUsers(alertViewModel: alertViewModel, isInitialLoad: true)
                }
            }
        }
    }
}
