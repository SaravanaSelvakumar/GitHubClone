//
//  UserProfileView.swift
//  GithubClone
//
//  Created by Manikandan Arumugam on 17/07/25.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var alertViewModel: AlertViewModel
    @StateObject private var viewModel = UserProfileViewModel()
    @State private var repos: [GitHubRepo] = []
    let userDetail: GitHubUser
    
    var body: some View {
        let userName = viewModel.userDetail?.login
        VStack(spacing: 16) {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let detail = viewModel.userDetail {
                GitHubUserDetailView(detail: detail, repos: repos)
            } else {
                Text("No user details available.")
                Spacer()
            }
        }
        .padding()
        .navigationTitle(userName ?? "")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchUserDetail(username: userDetail.login, alertViewModel: alertViewModel)
            viewModel.fetchUserRepositories(username: userDetail.login) { fetchedRepos in
                self.repos = fetchedRepos
            }
        }
        .alert(isPresented: $alertViewModel.showAlert) {
            Alert(title: Text(alertViewModel.alertTitle),
                  message: Text(alertViewModel.alertMessage),
                  dismissButton: .default(Text("OK")))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.primary)
                }
            }
        }
    }
}


struct GitHubUserDetailView: View {
    let detail: GitHubUserDetail
    let repos: [GitHubRepo]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                AsyncImage(url: URL(string: detail.avatar_url)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                
                VStack(spacing: 5) {
                    Text(detail.name ?? detail.login)
                        .font(.title2)
                        .bold()
                    
                    Text(detail.login)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let bio = detail.bio {
                    Text(bio)
                        .font(.body)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }
                
                if let location = detail.location {
                    HStack {
                        Image(systemName: "location.fill")
                        Text(location)
                    }
                }
                
                if let company = detail.company {
                    HStack {
                        Image(systemName: "building.2.fill")
                        Text(company)
                    }
                    .foregroundColor(.secondary)
                }
                
                HStack(spacing: 20) {
                    VStack {
                        Text("\(detail.followers)")
                            .bold()
                        Text("Followers")
                            .font(.caption)
                    }
                    VStack {
                        Text("\(detail.following)")
                            .bold()
                        Text("Following")
                            .font(.caption)
                    }
                    VStack {
                        Text("\(detail.public_repos)")
                            .bold()
                        Text("Repos")
                            .font(.caption)
                    }
                }
                .padding()
                
                Link(destination: URL(string: detail.html_url)!) {
                    Text("View on GitHub")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                
                if !repos.isEmpty {
                    RepoListView(repos: repos)
                }
                Spacer()
            }
            .padding()
        }
    }
}
