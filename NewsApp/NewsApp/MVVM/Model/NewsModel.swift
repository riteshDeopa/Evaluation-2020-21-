//
//  BaseModel.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit

class NewsModel: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Articles]?
}

class Articles: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    let source: Source?
}

class Source: Codable {
    let id: String?
    let name: String?
}
