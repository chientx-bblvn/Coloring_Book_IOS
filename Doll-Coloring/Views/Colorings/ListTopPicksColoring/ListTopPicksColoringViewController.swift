//
//  ListTopPicksColoringViewController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//

import UIKit

class ListTopPicksColoringViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var colorings: [ColoringModel] = []
    private var coloringLocal: [ColoringHistoryModel] = []
    private var numberClick: Int = 3
    private var indexCategory: Int = -1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        coloringLocal = SQLiteManager.shared.selectionColorings()
        
        if indexCategory != -1 {
           let cell =  tableView.cellForRow(at: IndexPath(row: indexCategory, section: 0)) as? CategoryColoringCell
            cell?.reloadCollectionView(coloringLocal: coloringLocal)
        } else {
            tableView.reloadData()
        }
        
    }
    
    public func reloadData(data: [ColoringModel]) {
        colorings = data
        tableView.reloadData()
    }
    
    
    private func setupTableView() {
        tableView.register(cellType: CategoryColoringCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension ListTopPicksColoringViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CategoryColoringCell.self)
        let coloring = colorings[indexPath.row]
        cell.setupView(coloringLocal: coloringLocal, coloringModel: coloring)
        cell.onClickSeeAll = {
            AppRouter.shared.navigate(to: DetailColoringRoute.main(coloring: coloring), with: .push)
        }
        cell.didSelectItemColoring = {[weak self] item in
            guard let self = self else {return}
            let data = item
            guard !(data.isPremium ?? false) else {
                if let _ = SQLiteManager.shared.selectionColoringsRew().first(where: { $0.filePath == data.filePath }) {
                    if let colorLocal = SQLiteManager.shared.selectionColorings().first(where: { $0.filePath == data.filePath }) {
                        AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .coloring, coloringAPI: data), with: .modal)
                    } else {
                        AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .coloring), with: .modal)
                    }
                    return
                }
                SQLiteManager.shared.insertTableColoringRew(data: data)

                if let colorLocal = SQLiteManager.shared.selectionColorings().first(where: { $0.filePath == data.filePath }) {
                    AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .coloring, coloringAPI: data), with: .modal)
                } else {
                    AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .coloring), with: .modal)
                }
                return
            }
            self.indexCategory = indexPath.row
            self.numberClick += 1
            guard self.numberClick >= UserDefaultManager.numberClickItemAllTopic  else {
                if let colorLocal = self.coloringLocal.first(where: {$0.filePath == data.filePath}) {
                    AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .coloring, coloringAPI: data), with: .modal)
                } else {
                    AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .coloring), with: .modal)
                }
                return
            }
            
            self.numberClick = 0
            if let colorLocal = self.coloringLocal.first(where: { $0.filePath == data.filePath }) {
                AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .coloring, coloringAPI: data), with: .modal)
            } else {
                AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .coloring), with: .modal)
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = UIScreen.main.bounds.width - 32
        return width * (200 / width)
    }
   
}

enum TypeHome: String, CaseIterable {
    case ads = ""
    case feature = "Discover"
    case trending = "Trending"
}
