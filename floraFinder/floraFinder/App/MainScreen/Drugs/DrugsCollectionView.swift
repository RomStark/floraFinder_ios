//
//  DrugsCollectionView.swift
//  floraFinder
//
//  Created by Al Stark on 16.05.2024.
//


import DeclarativeLayoutKit
import RxDataSources
import RxSwift
import RxCocoa


typealias DrugsRxDataSource = RxCollectionViewSectionedAnimatedDataSource<DrugsSectionModel>

public typealias DrugsSectionModel = AnimatableSectionModel<String, DrugCellViewModel>


public struct DrugCellViewModel {
    public var id: String
    let image: Observable<UIImage?>
    let onTap: () -> Void
    let name: String
    
    public init(model: Drugs, imageLoader: @escaping ImageLoader, onTap: @escaping () -> Void) {
        self.id = model.id
        self.image = imageLoader(model.imageURL).asObservable()
        self.name = model.name
        self.onTap = onTap
    }
}

extension DrugCellViewModel: IdentifiableType {
    public var identity: String {
        return id
    }
}

extension DrugCellViewModel: Equatable {
    public static func == (lhs: DrugCellViewModel, rhs: DrugCellViewModel) -> Bool {
        lhs.identity == rhs.identity
    }
}

// MARK: - CollectionView Cell
class DrugCell: CommonInitCollectionViewCell {
    private weak var mainImageView: UIImageView!
    private weak var button: UIButton!
    private weak var addButton: Button!
    private weak var dayCountLabel: UILabel!
    private weak var nameLabel: UILabel!
    
    override func commonInit() {
        super.commonInit()
        contentView
            .add {
                UIStackView()
                    .axis(.vertical)
                    .append {
                        UIImageView()
                            .assign(to: &mainImageView)
                            .clipsToBounds(true)
                            .contentMode(.scaleAspectFill)
                            .cornerRadius(12)
                            .borderWidth(2)
                            .borderColor(.border)
                            .heightAnchor(100)
                        UILabel()
                            .assign(to: &nameLabel);
                        UILabel()
                            .assign(to: &dayCountLabel)
                    }
                    .spacing(8)
                    .verticalAnchor(8)
                    .horizontalAnchor(8)
                    
                UIButton()
                    .assign(to: &button)
                    .edgesAnchors()
            }
            .backgroundColor(.cellBackGround)
            .borderWidth(0.5)
            .borderColor(.white)
            .cornerRadius(12)
    }
    
    public func configure(with model: DrugCellViewModel) -> Disposable {
        button.onTap(overwrite: true, model.onTap)
        nameLabel.text(model.name)
        return model.image.bind(to: mainImageView.rx.image)
    }
}
