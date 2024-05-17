//
//  DrugsInfoViewModel.swift
//  floraFinder
//
//  Created by Al Stark on 16.05.2024.
//


import RxSwift
import RxCocoa


public final class DrugsInfoViewModel: FlowController {
    public enum Event {
    }
    
    public var onComplete: CompletionBlock?
   
    private let disposeBag = DisposeBag()
    
    private let imageRelay = BehaviorRelay<UIImage?>(value: nil)
    private let infoCellsRelay = BehaviorRelay<[DrugsInfoStackViewModel]>(value: [])
   
    
    private let service: UserService
    private let imageLoader: ImageLoader
    private let drug: Drugs
    
    public init(drug: Drugs, service: UserService, imageLoader: @escaping ImageLoader) {
        self.drug = drug
        self.service = service
        self.imageLoader = imageLoader
        
        imageLoader(drug.imageURL).subscribe { [weak self] image in
            self?.imageRelay.accept(image)
        }
        .disposed(by: disposeBag)
        infoCellsRelay.accept(cellsViewModels(drug: drug))
    }
    
    private func cellsViewModels(drug: Drugs) -> [DrugsInfoStackViewModel] {
        [DrugsInfoStackViewModel(title: "название", value: drug.name),
         DrugsInfoStackViewModel(title: "описание", value: drug.description),
         
        ]
    }
}

// MARK: - Биндинги для контроллера
extension DrugsInfoViewModel: DrugsInfoViewControllerBindings {
    public var image: RxCocoa.Driver<UIImage?> {
        imageRelay.asDriver(onErrorJustReturn: nil)
    }
    
    public var infoCells: RxCocoa.Driver<[DrugsInfoStackViewModel]> {
        infoCellsRelay.asDriver(onErrorJustReturn: [])
    }
}

public struct DrugsInfoStackViewModel {
    var title: String
    var value: String
}

public final class DrugsInfoStackView: UIView {
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
    
    func configure(with viewModel: DrugsInfoStackViewModel) {
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
