//
//  HomeModel.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 08/04/2024.
//  
//

import UIKit

struct HomeModel: Codable {
    var name: String
    var desc: String
    var id: Int
}

extension HomeModel {

}



struct ImageColoring: Codable {
    var guid, storageZoneName, path, objectName: String?
    var length: Int?
    var lastChanged: String?
    var serverID, arrayNumber: Int?
    var isDirectory: Bool?
    var userID, contentType, dateCreated: String?
    var storageZoneID: Int?
    var checksum, replicatedZones: String?

    enum CodingKeys: String, CodingKey {
        case guid = "Guid"
        case storageZoneName = "StorageZoneName"
        case path = "Path"
        case objectName = "ObjectName"
        case length = "Length"
        case lastChanged = "LastChanged"
        case serverID = "ServerId"
        case arrayNumber = "ArrayNumber"
        case isDirectory = "IsDirectory"
        case userID = "UserId"
        case contentType = "ContentType"
        case dateCreated = "DateCreated"
        case storageZoneID = "StorageZoneId"
        case checksum = "Checksum"
        case replicatedZones = "ReplicatedZones"
    }
}

