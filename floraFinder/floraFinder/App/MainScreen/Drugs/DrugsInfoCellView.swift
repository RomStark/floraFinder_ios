//
//  DrugsInfoCellView.swift
//  floraFinder
//
//  Created by Al Stark on 15.05.2024.
//

import DeclarativeLayoutKit
import RxSwift
import RxCocoa


public struct DrugsInfoCellViewModel {
    var name: String
    var description: String
    var image: Observable<UIImage?>
    var onTap: () -> ()
}

public final class DrugsInfoCellView: UIView {
    private weak var mainImage: UIImageView!
    private weak var titleLabel: UILabel!
    private weak var valueLabel: UILabel!
    private weak var onTapButton: Button!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        add {
            UIImageView()
                .assign(to: &mainImage)
                .clipsToBounds(true)
                .contentMode(.scaleAspectFill)
                .leftAnchor(10)
                .verticalAnchor(10)
                .widthAnchor(60)
                .heightAnchor(60)
            UIStackView()
                .axis(.vertical)
                .append {
                    UILabel()
                        .assign(to: &titleLabel)
                        .set(fontStyle: .size(.medium))
                        
        //                .verticalAnchor(10)
                    
                    
                    UILabel()
                        .assign(to: &valueLabel)
                        .numberOfLines(3)
                        .set(fontStyle: .size(.medium))
                        
                        
                }
                .spacing(5)
                .leftAnchor(10.from(mainImage.rightAnchor))
                .rightAnchor(10)
                .verticalAnchor(10)
            
            Button()
                .assign(to: &onTapButton)
                .verticalAnchor(0)
                .horizontalAnchor(0)
        }
        .backgroundColor(.cellBackGround)
        .cornerRadius(12)

    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }

    func configure(with viewModel: DrugsInfoCellViewModel) -> Disposable {
        titleLabel.styledText(viewModel.name)
        valueLabel.styledText(viewModel.description)
        onTapButton.onTap(overwrite: true, {
            viewModel.onTap()
        })
        return [
            viewModel.image.subscribe(mainImage.rx.image)
        ]
//        linkButton.styledText(viewModel.url)
//        linkButton.onTap(overwrite: true, {
//            viewModel.openURL()
//        })
//        copyButton.onTap(overwrite: true, {
//            viewModel.copyURL()
//        })
    }
    
}

