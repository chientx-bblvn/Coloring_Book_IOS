//
//  SQLiteManager.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 15/4/24.
//

import Foundation
import SQLite

enum ArchiveFileLocal: String, CaseIterable {
    case Coloring = "Colorings"
    case Theme = "Themes"
    case ColoringSave = "ColoringHistory"
    case ColoringRew = "ColoringRew"
}

class FileManagerLocal {
    
    static let shared = FileManagerLocal()
    
    private let fileManager = FileManager.default
    
    func getDocumentsDirectory() -> URL {
        let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func getFileFoderFileUssing(typeFile: ArchiveFileLocal, file: String = "") -> URL {
        var url = getDocumentsDirectory().appendingPathComponent(typeFile.rawValue)
        if file.isEmpty {
            return url
        }
        url = url.appendingPathComponent(file)
        return url
    }
    
    func getFileInDoucment(url: URL) -> [String] {
        do {
            let fileUrl = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil).map({$0.lastPathComponent})
            return fileUrl
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func getFileColoringlocal() -> [String] {
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: getFileFoderFileUssing(typeFile: .ColoringSave),
                                                                   includingPropertiesForKeys: [.contentModificationDateKey],
                                                                   options:.skipsHiddenFiles)
            return urls.map { url in
                (url.lastPathComponent, (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
            }.sorted(by: { $0.1 > $1.1 }).map { $0.0 }// extract file names
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func getFileColoringlocalURL() -> [URL] {
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: getFileFoderFileUssing(typeFile: .ColoringSave),
                                                                   includingPropertiesForKeys: [.contentModificationDateKey],
                                                                   options:.skipsHiddenFiles)
            return urls
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func checkFileExits(typeFile: ArchiveFileLocal, fileName: String) -> Bool {
        let urlPath = getDocumentsDirectory().appendingPathComponent(typeFile.rawValue)
        let path = urlPath.appendingPathComponent(fileName).path
        return fileManager.fileExists(atPath: path)
    }
    
    func addImageToLocal(typeFile: ArchiveFileLocal, fileName: String, image: UIImage) -> Bool  {
        
        let urlPath = getDocumentsDirectory().appendingPathComponent(typeFile.rawValue)
        let url = urlPath.appendingPathComponent(fileName)
        
        do {
            if let data = image.pngData() {
                try data.write(to: url)
            }
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
        
    }
    
    
    func createFolderManager(fileName: String) {
        let pathFile = getDocumentsDirectory()
        let dataPath = pathFile.appendingPathComponent(fileName)
        
        if !(fileManager.fileExists(atPath: dataPath.path)) {
            do {
                try fileManager.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true)
            } catch {
                print("Create file Manager Err \(error.localizedDescription)")
            }
        } else {
            print("File has been created")
        }
    }
    
    func delete(typeFile: ArchiveFileLocal, fileName: String) -> Bool {
        var urlPath = getDocumentsDirectory().appendingPathComponent(typeFile.rawValue)
        if !fileName.isEmpty {
            urlPath = urlPath.appendingPathComponent(fileName)
        }
        do {
            try FileManager.default.removeItem(at: urlPath)
            return true
        }
        catch {
            print(error.localizedDescription)
        }
        return false
    }
    
    func deleteFile(typeFile: ArchiveFileLocal, fileName: String) {
        var urlPath = getDocumentsDirectory().appendingPathComponent(typeFile.rawValue)
        if !fileName.isEmpty {
            urlPath = urlPath.appendingPathComponent(fileName)
        }
        do {
            try FileManager.default.removeItem(at: urlPath)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

class SQLiteManager {
    static let shared =  SQLiteManager()
    
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    
    let dbName = "/DollColoring.sqlite3"
    
    var db: Connection?
    
    let tableColoring = Table("Coloring")
    let tableTheme = Table("ThemeAlbum")
    let tableColoringRew = Table("TableColoringRew")
    let tableGitColoring = Table("TableGitColoring")
    
    func connectionDatabase() {
        if let foder =  path {
            do {
                db = try Connection("\(foder)\(dbName)")
                tablesColoringExists()
                tablesColoringRewExists()
                createTableGitColoring()
                tablesGitColoringExists()
            } catch {
                print("Connect DB fail")
            }
        }
    }
    
    func tablesColoringExists() {
        guard let itExists = try? db?.scalar(tableColoring.exists), itExists else {
            createTableColoring()
            return
        }
    }
    
    func tablesColoringRewExists() {
        guard let itExists = try? db?.scalar(tableColoring.exists), itExists else {
            createTableColoringRew()
            return
        }
    }
    
    func tablesGitColoringExists() {
        guard let itExists = try? db?.scalar(tableGitColoring.exists), itExists else {
            createTableGitColoring()
            return
        }
    }
    
    
    func createTableColoringRew() {
        let filePath = Expression<String>("filePath")
        do {
            try db?.run(tableColoringRew.create(ifNotExists: true){ column in
                column.column(filePath, primaryKey: true)
            })
        } catch {
            print("Create table coloring rew fail", error.localizedDescription)
        }
    }
    
    func createTableColoring() {
        let id = Expression<Int>("id")
        let filePath = Expression<String>("filePath")
        let fileLocal = Expression<String>("fileLocal")
        let historys = Expression<String>("historys")
        do {
            try db?.run(tableColoring.create(ifNotExists: true){ column in
                column.column(id, primaryKey: true)
                column.column(filePath)
                column.column(fileLocal)
                column.column(historys)
            })
        } catch {
            print("Create table coloring fail", error.localizedDescription)
        }
    }
    
    func createTableGitColoring() {
        let id = Expression<Int>("id")
        let name = Expression<String>("name")
        do {
            try db?.run(tableGitColoring.create(ifNotExists: true, block: { column in
                column.column(id, primaryKey: true)
                column.column(name)
            }))
        } catch {
            print("Create table daily coloring fail", error.localizedDescription)
        }
    }
    
    func insertTableGitColoring(_id: Int, _name: String) {
        let id = Expression<Int>("id")
        let name = Expression<String>("name")
        let insert = tableGitColoring.insert(id <-  _id,
                                          name <- _name)
        do {
            try db?.run(insert)
        } catch {
            print("Insert fail", error.localizedDescription)
        }
    }
    
    func insertTableColoring(data: ColoringHistoryModel) {
        let id = Expression<Int>("id")
        let filePath = Expression<String>("filePath")
        let fileLocal = Expression<String>("fileLocal")
        let historys = Expression<String>("historys")
        let history = convertModelToString(model: data.historys) ?? ""
        let insert = tableColoring.insert(id <-  data.id,
                                          filePath <- data.filePath,
                                          fileLocal <- data.fileLocal,
                                          historys <-  history)
        do {
            try db?.run(insert)
        } catch {
            print("Insert fail", error.localizedDescription)
        }
    }
    
    func insertTableColoringRew(data: ColoringImage) {
        let filePath = Expression<String>("filePath")
        let insert = tableColoringRew.insert(filePath <- data.filePath ?? "")
        do {
            try db?.run(insert)
        } catch {
            print("Insert fail", error.localizedDescription)
        }
    }
    
    func selectionColorings() -> [ColoringHistoryModel] {
        let id = Expression<Int>("id")
        let filePath = Expression<String>("filePath")
        let fileLocal = Expression<String>("fileLocal")
        let historys = Expression<String>("historys")
        do {
            let collections = try db?.prepare(tableColoring)
            return collections?.map({ color in
                ColoringHistoryModel(id: color[id], filePath: color[filePath], fileLocal: color[fileLocal], historys: color[historys].getDataModel() ?? [])
            }) ?? []
        } catch {
            print("select TableColoring fail: ", error.localizedDescription)
            return []
        }
    }
    
    func selectionColoringsRew() -> [ColoringImage] {
        let filePath = Expression<String>("filePath")
        do {
            let collections = try db?.prepare(tableColoringRew)
            return collections?.map({ color in
                ColoringImage(filePath: color[filePath], filePreview: nil, isPremium: nil)
            }) ?? []
        } catch {
            print("select TableColoring fail: ", error.localizedDescription)
            return []
        }
    }
    
    func selectionGitColorings() -> [GitDailyColoring] {
        let id = Expression<Int>("id")
        let name = Expression<String>("name")
        do {
            let collections = try db?.prepare(tableGitColoring)
            return collections?.map({ color in
                GitDailyColoring(id: color[id], filePath: color[name])
            }) ?? []
        } catch {
            print("select TableColoring fail: ", error.localizedDescription)
            return []
        }
    }
    
    func updateColorings(data: ColoringHistoryModel) -> Bool {
        let id = Expression<Int>("id")
        let historys = Expression<String>("historys")
        guard let history = convertModelToString(model: data.historys) else {
            return false
        }
        do {
            let coloring = tableColoring.filter(id == data.id)
            try db?.run(coloring.update(historys <- history))
            return true
        } catch {
            print("updateColorings error", error.localizedDescription)
            return false
        }
    }
    
    func deleteColorings(id: Int) {
        let fieldId = Expression<Int>("id")
        let coloringFieldValueID = Expression<Int>(value: id)
        do {
            let collection = tableColoring.filter(fieldId == coloringFieldValueID)
            try db?.run(collection.delete())
        } catch {
            print("update error", error.localizedDescription)
        }
    }
}

extension String {
    func getDataModel<A: Codable>(fromLocalJson filePath: String = "") -> A? {
        if let jsonData = self.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                let jsonArray = try decoder.decode(A.self, from: jsonData)
                return jsonArray
            } catch {
                print("Lỗi khi phân tích chuỗi JSON: \(error.localizedDescription)")
                return nil
            }
        } else {
            return nil
        }
    }
}

func convertModelToString(model: [HistoryModel]) -> String? {
    do {
        let jsonData = try JSONEncoder().encode(model)
        let jsonString = String(data: jsonData, encoding: .utf8)
        return jsonString
    } catch {
        print("Không thể chuyển đổi thành chuỗi JSON. \(error.localizedDescription)")
        return nil
    }
}

struct ColoringLocalModel: Codable {
    var id: Int
    var url: String
    var filePath: [String]
}

struct GitDailyColoring {
    var id: Int
    var filePath: String
}
