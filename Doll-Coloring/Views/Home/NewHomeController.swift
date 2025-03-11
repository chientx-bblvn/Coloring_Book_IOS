//
//  NewHomeController.swift
//  Doll-Coloring
//
//  Created by Tiến Đoàn on 11/3/25.
//

import UIKit

class NewHomeController: UIViewController {
    
    var viewModel: HomeVM!
    
    @IBOutlet weak var btnPremium: UIImageView!
    
    @IBOutlet weak var lbColoring: UILabel!
    
    @IBOutlet weak var coloringTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()

       
    }
    private func setupView() {
        coloringTableView.delegate = self
        coloringTableView.dataSource = self
        coloringTableView.register(UINib(nibName: "ColoringBookCell", bundle: nil), forCellReuseIdentifier: "ColoringBookCell")
        coloringTableView.contentInset.bottom = 160
        btnPremium.image = R.image.ic_btn_premium()
    }
    func loadData() {
        viewModel.getNewColorings { [weak self] in
            guard let self = self else {return}
            self.coloringTableView.reloadData()
        }
    }
    

}
extension NewHomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.colorings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColoringBookCell", for:  indexPath) as! ColoringBookCell
        let category = viewModel.colorings[indexPath.row]
        let categoryName = category.categoryName ?? "Unknown Category"
        cell.setupCell(title: categoryName, itemColoring: category.imageUrls ?? [])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = UIScreen.main.bounds.width - 32
        let cellHeight = width * 0.6
        return cellHeight
    }
    
}
