//
//  PlantsCollectionView.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import DeclarativeLayoutKit
import RxDataSources
import RxSwift
import RxCocoa


typealias PlantsRxDataSource = RxCollectionViewSectionedAnimatedDataSource<PlantSectionModel>

public typealias PlantSectionModel = AnimatableSectionModel<String, PlantCellViewModel>


public struct PlantCellViewModel {
    public var id: String
    let image: Observable<UIImage?>
    let onTap: () -> Void
    let name: String
    let dayCount: String
    
    public init(model: Plant, imageLoader: @escaping ImageLoader, onTap: @escaping () -> Void) {
        self.id = model.id
        self.image = imageLoader(model.imageURL).asObservable()
        self.name = model.name
        self.dayCount = "полить через \(model.water_interval) дн."
        self.onTap = onTap
    }
}

extension PlantCellViewModel: IdentifiableType {
    public var identity: String {
        return id
    }
}

extension PlantCellViewModel: Equatable {
    public static func == (lhs: PlantCellViewModel, rhs: PlantCellViewModel) -> Bool {
        lhs.identity == rhs.identity
    }
}

// MARK: - CollectionView Cell
class PlantCell: CommonInitCollectionViewCell {
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
                            .cornerRadius(4)
                            .heightAnchor(100)
                        UILabel()
                            .assign(to: &nameLabel);
                        UILabel()
                            .assign(to: &dayCountLabel)
                    }
                    .spacing(8)
                    .verticalAnchor(5)
                    .horizontalAnchor(5)
                    
                UIButton()
                    .assign(to: &button)
                    .edgesAnchors()
            }
            .backgroundColor(.cellBackGround)
            .borderWidth(0.5)
            .borderColor(.white)
            .cornerRadius(8)
    }
    
    public func configure(with model: PlantCellViewModel) -> Disposable {
        button.onTap(overwrite: true, model.onTap)
        nameLabel.text(model.name)
        dayCountLabel.text(model.dayCount)
        return model.image.bind(to: mainImageView.rx.image)
    }
}
