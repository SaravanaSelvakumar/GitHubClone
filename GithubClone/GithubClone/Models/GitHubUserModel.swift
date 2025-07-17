//
//  GitHubUserModel.swift
//  GithubClone
//
//  Created by Manikandan Arumugam on 17/07/25.
//

import Foundation

struct SearchResult: Codable {
    let items: [GitHubUser]
}

struct GitHubUser: Identifiable, Codable {
    let id: Int
    let login: String
    let avatar_url: String
    let html_url: String
    let type: String
    var avatarURL: URL? {
        return URL(string: avatar_url)
    }
}
