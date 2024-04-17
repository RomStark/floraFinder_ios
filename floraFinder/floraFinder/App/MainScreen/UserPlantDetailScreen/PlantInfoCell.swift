//
//  PlantInfoCell.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import DeclarativeLayoutKit
import RxSwift
import RxCocoa


public struct PlantInfoCellViewModel {
    var title: String
    var value: String
}

public final class PlantInfoCellView: UIView {
    private weak var titleLabel: UILabel!
    private weak var valueLabel: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        add {
            UILabel()
                .assign(to: &titleLabel)
                .set(fontStyle: .size(.medium))
                .leftAnchor(5)
                .topAnchor(10)
//                .verticalAnchor(10)
            
            
            UILabel()
                .assign(to: &valueLabel)
                .numberOfLines(0)
                .set(fontStyle: .size(.medium))
                .topAnchor(10.from(titleLabel.bottomAnchor))
                .horizontalAnchor(5)
                .bottomAnchor(10)

                
        }
        .backgroundColor(.cellBackGround)
        .cornerRadius(12)

    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }

   
    
    func configure(with viewModel: PlantInfoCellViewModel) {
        titleLabel.styledText(viewModel.title)
        valueLabel.styledText(viewModel.value)
//        linkButton.styledText(viewModel.url)
//        linkButton.onTap(overwrite: true, {
//            viewModel.openURL()
//        })
//        copyButton.onTap(overwrite: true, {
//            viewModel.copyURL()
//        })
    }
    
}
