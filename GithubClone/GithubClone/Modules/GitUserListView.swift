//
//  GitUserListView.swift
//  GithubClone
//
//  Created by Manikandan Arumugam on 17/07/25.
//

import SwiftUI

struct GitUserListView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !viewModel.isSearching {
                Text("Most Active Contributors")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.primary)
                    .padding(.leading, 20)
                    .padding(.bottom)
            }
            
            LazyVStack(spacing: 16) {
                ForEach(viewModel.gitUserData.indices, id: \.self) { index in
                    let user = viewModel.gitUserData[index]
                    NavigationLink(destination: UserProfileView(userDetail: user).environmentObject(alertViewModel)) {
                        TopRatedListView(user: user)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onAppear {
                        let isLastItem = index == viewModel.gitUserData.count - 1
                        if  isLastItem,
                            !viewModel.isLastPage,
                            !viewModel.isLoading,
                            viewModel.shouldFetchNextPage,
                            !viewModel.isSearching {
                            viewModel.shouldFetchNextPage = false
                            viewModel.fetchTopGitHubUsers(alertViewModel: alertViewModel)
                        }
                    }
                }
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 5)
    }
}


struct TopRatedListView: View {
    let user: GitHubUser
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: user.avatarURL) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text(user.login)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(user.type)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            HStack {
                Image(systemName: "arrow.up.right.square")
            }
            .padding(.trailing)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

