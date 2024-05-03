//
//  MainColoringsModel.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import UIKit

// MARK: - ColoringModel
struct ColoringModel: Codable {
    let categoryName: String?
    let imageUrls: [ColoringImage]?
}

// MARK: - ImageURL
struct ColoringImage: Codable {
    let filePath: String?
    let isPremium: Bool?
}


struct ColoringHistoryModel: Codable {
    var id: Int
    var filePath: String
    var fileLocal: String
    var historys: [HistoryModel]
}

struct HistoryModel: Codable {
    var imagePath: String
    var strokes: [StrokeModel]
}

struct StrokeModel: Codable {
    var lineWidth: Double
    var color: String
    var id: Int
    var nameColor: String
    var points: [PointModel]
    var strokeRect: StrokeRectMode
}

struct PointModel: Codable {
    var x: Double
    var y: Double
}

struct StrokeRectMode: Codable {
    var x: Double
    var y: Double
    var width: Double
    var height: Double
}
