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
    let id: Int?
    let categoryName: String?
    let imageUrls: [ColoringImage]?
}

// MARK: - ImageURL
struct ColoringImage: Codable {
    let filePath: String?
    let filePreview: String?
    let isPremium: Bool?
}


struct ColoringHistoryModel: Codable {
    var id: Int
    var filePath: String
    var fileLocal: String
    var historys: [HistoryModel]

    /// Whole-percent progress > 0 — blank (0%) pages are not resumable.
    var hasResumableHistory: Bool {
        historys.contains { $0.isResumable }
    }

    var resumableHistories: [HistoryModel] {
        historys.filter(\.isResumable)
    }
}

struct HistoryModel: Codable {
    var imagePath: String
    var percent_complete: Double?
    var strokes: [StrokeModel]

    var isResumable: Bool {
        Int(((percent_complete ?? 0) * 100).rounded()) > 0
    }
}

struct StrokeModel: Codable {
    var lineWidth: Double
    var color: String
    var id: Int
    var nameColor: String
    var isPens: Bool?
    /// "pencil" | "brush" — nil treated as brush for older saves.
    var strokeKind: String?
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
