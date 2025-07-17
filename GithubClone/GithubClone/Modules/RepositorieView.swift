
//
//  RepositoeieView.swift
//  GithubClone
//
//  Created by Manikandan Arumugam on 17/07/25.
//

import SwiftUI

struct RepoListView: View {
    let repos: [GitHubRepo]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Popular Repositories")
                .font(.headline)
                .padding(.top)
                .padding(.bottom, 5)
            
            ForEach(repos) { repo in
                VStack(alignment: .leading, spacing: 12) {
                    Text(repo.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    if let desc = repo.description {
                        Text(desc)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(5)
                            .truncationMode(.tail)
                    }
                    
                    HStack(spacing: 12) {
                        Label("\(repo.stargazers_count)", systemImage: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        
                        Label("\(repo.forks_count)", systemImage: "tuningfork")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width - 32, alignment: .leading)
//                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
}
