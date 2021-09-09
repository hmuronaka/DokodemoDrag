//
//  CGRectExtensions.swift
//  DokodemoDrag
//
//  Created by MuronakaHiroaki on 2021/09/09.
//

import Foundation

extension CGRect {
    
    /// pointが4象限のどこに属するかを返す。
    /// - Parameter point: 対象の座標
    /// - Returns: 1~4
    func quardrant(point: CGPoint) -> Int {
        return (point.x >= self.midX ?
            (point.y <= self.midY ? 1 : 4) :
            (point.y <= self.midY ? 2 : 3))
    }
    
}
