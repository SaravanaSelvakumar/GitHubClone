//
//  GitHubUserDetail.swift
//  GithubClone
//
//  Created by Manikandan Arumugam on 17/07/25.
//

import Foundation

struct GitHubUserDetail: Decodable, Identifiable {
    let id: Int
    let login: String
    let avatar_url: String
    let name: String?
    let bio: String?
    let location: String?
    let company: String?
    let blog: String?
    let followers: Int
    let following: Int
    let public_repos: Int
    let html_url: String
}
