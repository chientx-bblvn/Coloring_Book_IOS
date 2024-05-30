//
//  Grid.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 30/5/24.
//

import UIKit

//-----------------------------------------------------------------------------------------------------------------------------------------------
class Grid {
    
    static var gridColumns: Int = 3
    
    static var gridMargin: CGFloat = 5.0
    static var pageMargin: CGFloat = 10.0
    static var gridCorner: CGFloat = 5.0
    
    static var widthGridImage: CGFloat = 0.0
    
    static var pageTitleFont = UIFont.systemFont(ofSize: 17.0, weight: .bold)
    static var pageTextFont = UIFont.systemFont(ofSize: 15.0, weight: .light)
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    class func columns() -> Int {
        
        return gridColumns
    }
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    class func columns() -> CGFloat {
        
        return CGFloat(gridColumns)
    }
}
