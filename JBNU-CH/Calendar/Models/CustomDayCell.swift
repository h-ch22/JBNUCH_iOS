//
//  CustomDayCell.swift
//  JBNU-CH
//
//  Created by Changjin Ha on 2022/09/23.
//

import UIKit

final class CustomDayCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = CGRect(origin: .zero, size: frame.size)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
