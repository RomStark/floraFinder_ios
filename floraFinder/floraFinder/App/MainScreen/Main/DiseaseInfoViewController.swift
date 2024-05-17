//
//  DiseaseInfoViewController.swift
//  floraFinder
//
//  Created by Al Stark on 24.04.2024.
//


import DeclarativeLayoutKit
import RxDataSources
import RxSwift
import RxCocoa
import AVFoundation


public protocol DiseaseInfoViewControllerBindings {
    var image: Driver<UIImage?> { get }
    var diseaseName: Driver<String> { get }
    var diseaseInfo: Driver<String> { get }
    var drugs: Driver<[DrugsInfoCellViewModel]> { get }
}

public final class DiseaseInfoViewController: ViewController {
    private weak var mainImage: UIImageView!
    
    private weak var diseaseNameLabel: UILabel!
    private weak var diseaseInfoLabel: UILabel!
    private weak var drugsStackView: UIStackView!
    private weak var scrollView: UIScrollView!
    
    public override func loadView() {
        view = mainView()
    }
    
    private let disposeBag = DisposeBag()
    
    
    public func bind(to bindings: DiseaseInfoViewControllerBindings) -> Disposable {
        return [
            bindings.diseaseInfo.drive(diseaseInfoLabel.rx.text),
            bindings.diseaseName.drive(diseaseNameLabel.rx.text),
            
            
            bindings.drugs.map({ [unowned self] drugs in
                drugs.map { drug in
                    self.makeDrugCell(with: drug)
                }
            }).drive(drugsStackView.rx.views),
        ]
    }
    
    private func makeDrugCell(with viewModel: DrugsInfoCellViewModel) -> UIView {
        let view = DrugsInfoCellView()
        view.configure(with: viewModel).disposed(by: disposeBag)
        return view
    }
}

private extension DiseaseInfoViewController {
    func mainView() -> UIView {
        let mainView = UIView()
            .backgroundColor(.mainBackGround)
        
        let scrollView = UIScrollView()
            .assign(to: &scrollView)
            .backgroundColor(.mainBackGround)
        let commonView = UIView()
            .backgroundColor(.mainBackGround)
        
        return commonView.add {
            scrollView.add {
                mainView.add {
                    UIStackView()
                        .axis(.vertical)
                        .spacing(25)
                        .append {
                            UILabel()
                                .assign(to: &diseaseNameLabel)
                                .textAlignment(.center)
                                .numberOfLines(0)
                            
                            UILabel()
                                .assign(to: &diseaseInfoLabel)
                                .numberOfLines(0)
                            UIStackView()
                                .assign(to: &drugsStackView)
                                .axis(.vertical)
                                .spacing(15)
                        }
                        .verticalAnchor(20)
                        .horizontalAnchor(20)
//                    UILabel()
//                        .assign(to: &diseaseNameLabel)
//                        .textAlignment(.center)
//                        .numberOfLines(0)
//                        .horizontalAnchor(20)
//                    //                .bottomAnchor(40)
//                        .topAnchor(30)
//
//                    UILabel()
//                        .assign(to: &diseaseInfoLabel)
//                        .numberOfLines(0)
//                        .horizontalAnchor(20)
//                        .topAnchor(30.from(diseaseNameLabel.bottomAnchor))
////                        .bottomAnchor(15)
//
//                    UIStackView()
//                        .assign(to: &drugsStackView)
//                        .axis(.vertical)
//                        .spacing(15)
//                        .horizontalAnchor(20)
//                    //                .bottomAnchor(40)
//                        .topAnchor(20.from(diseaseInfoLabel.bottomAnchor))
//                        .bottomAnchor(15)
                }
                .edgesAnchors()
                .widthAnchor(scrollView.widthAnchor)
                .heightAnchor(scrollView.heightAnchor.orGreater)
                
            }
            .topAnchor(20.from(commonView.safeAreaLayoutGuide.topAnchor))
            .bottomAnchor(mainView.bottomAnchor)
            .horizontalAnchor(0)
            .widthAnchor(mainView.widthAnchor)
            
        }
    }
}
