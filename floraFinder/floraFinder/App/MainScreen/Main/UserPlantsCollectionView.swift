//
//  UserPlantsCollectionView.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import DeclarativeLayoutKit
import RxDataSources
import RxSwift
import RxCocoa


typealias UserPlantsRxDataSource = RxCollectionViewSectionedAnimatedDataSource<UserPlantSectionModel>

public typealias UserPlantSectionModel = AnimatableSectionModel<String, UserPlantCellViewModel>


public struct UserPlantCellViewModel {
    public var id: String
    let image: Observable<UIImage?>
    let onTap: () -> Void
    let onTapWatering: () -> Void
    let name: String
    let dayCount: String
    let waterInterval: Int
    
    public init(model: UserPlant, imageLoader: @escaping ImageLoader, onTap: @escaping () -> Void, onTapWatering: @escaping () -> Void) {
        self.id = model.id
        self.image = imageLoader(model.imageURL).asObservable()
        self.name = model.name
        let waterDay = model.last_watering + (model.water_interval * 60 * 60 * 24) - Int(Date(timeIntervalSinceNow: 0).timeIntervalSince1970)
        self.dayCount = waterDay < 0 ? "полив сегодня" : "полив через \(Int(waterDay / (60*60*24)))"
        self.onTap = onTap
        self.onTapWatering = onTapWatering
        self.waterInterval = model.water_interval
    }
}

extension UserPlantCellViewModel: IdentifiableType {
    public var identity: String {
        return id
    }
}

extension UserPlantCellViewModel: Equatable {
    public static func == (lhs: UserPlantCellViewModel, rhs: UserPlantCellViewModel) -> Bool {
        lhs.identity == rhs.identity
    }
}

// MARK: - CollectionView Cell
class UserPlantCell: CommonInitCollectionViewCell {
    private weak var mainImageView: UIImageView!
    private weak var button: UIButton!
    private weak var dayCountLabel: UILabel!
    private weak var nameLabel: UILabel!
    private weak var wateringButton: UIButton!
    
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
                            .cornerRadius(12)
                            .borderWidth(2)
                            .contentMode(.scaleAspectFill)
                            .borderColor(.border)
                            .heightAnchor(100)
                        UIStackView()
                            .axis(.horizontal)
                            .append {
                                UILabel()
                                    .assign(to: &nameLabel)
                                
                                UIButton()
                                    .assign(to: &wateringButton)
                                    .image(UIImage(named: "drop"))
                                    .cornerRadius(18)
                                    .clipsToBounds(true)
                                    .borderWidth(1)
                                    .borderColor(.border)
                                    .shadowColor(.black)
                                    .shadowOffset(CGSize(width: 2, height: 2))
                                    .shadowOpacity(0.5)
                                    .shadowRadius(2)
                                    .sizeAnchor(36)
                                    .activate()
//                                    .rightAnchor(3)
//                                    .topAnchor(10)
                            }
                            .spacing(8)
                       
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
        
//        wateringButton.becomeFirstResponder()
    }
    
    public func configure(with model: UserPlantCellViewModel) -> Disposable {
        button.onTap(overwrite: true, model.onTap)
        wateringButton.onTap(overwrite: true, { [weak self] in
            model.onTapWatering()
            self?.dayCountLabel.styledText("полив через \(model.waterInterval)")
        })
        nameLabel.text(model.name)
        dayCountLabel.text(model.dayCount)
        return model.image.bind(to: mainImageView.rx.image)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let wateringButtonPoint = wateringButton.convert(point, from: self)
        if wateringButton.point(inside: wateringButtonPoint, with: event) {
            return wateringButton
        }
        return super.hitTest(point, with: event)
    }
}

open class CommonInitCollectionViewCell: UICollectionViewCell {
    open var disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    open func commonInit() {
        // point to override
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}
