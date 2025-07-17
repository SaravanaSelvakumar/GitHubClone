//
//  GitHubRepoModel.swift
//  GithubClone
//
//  Created by Manikandan Arumugam on 17/07/25.
//

import Foundation

struct GitHubRepo: Decodable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let stargazers_count: Int
    let forks_count: Int
}
