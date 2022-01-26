//
//  CustomButton.swift
//  nabelova_1PW7
//
//  Created by Наталья Белова on 25.01.2022.
//

import Foundation
import UIKit

final class CustomButton: UIButton {

    private let title: UILabel = {
        let label = UILabel()
        return label
    }()

    
    override init(frame: CGRect) {
        self.viewModel = nil
        super.init(frame: frame)
        
    }
    
    let viewModel: CustomButtonViewModel?
    init(with viewModel: CustomButtonViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configure(with: viewModel)
        
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func configure(with viewModel: CustomButtonViewModel) {
        layer.masksToBounds = true
        title.text = viewModel.title
        title.textColor = viewModel.textColor
        backgroundColor = viewModel.backgroundColor
//        guard !title.isDescendant(of: self) else {
//            return
//        }
//        addSubview(title)
        setTitle(viewModel.title, for: .normal)
        setTitleColor(viewModel.textColor, for: .normal)
    }
}
