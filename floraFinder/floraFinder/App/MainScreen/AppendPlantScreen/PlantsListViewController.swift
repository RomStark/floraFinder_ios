//
//  PlantsListViewController.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import DeclarativeLayoutKit
import RxDataSources
import RxSwift
import RxCocoa


public protocol PlantsListViewControllerBindings {
    var plantsCells: Driver<[PlantSectionModel]> { get }
//    var searchQuery: Driver<String> { get }
    var searchQuery: Binder<String> { get }
    var tapCamera: Binder<Void> { get }
}

public final class PlantsListViewController: ViewController {
    private weak var label: UILabel!
    private weak var collection: UICollectionView!
    private weak var searchBar: UISearchBar!
    private weak var button: UIButton!
    
    public override func loadView() {
        view = mainView()
    }
    
    public func bind(to bindings: PlantsListViewControllerBindings) -> Disposable {
        return [
            bindings.plantsCells.drive(collection.rx.items(dataSource: dataSource())),
            searchBar.rx.text.orEmpty.distinctUntilChanged().bind(to: bindings.searchQuery),
            button.rx.tap.bind(to: bindings.tapCamera)
        ]
    }
}

private extension PlantsListViewController {
    func dataSource() -> PlantsRxDataSource {
        PlantsRxDataSource(configureCell: { _, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PlantCell.self), for: indexPath) as! PlantCell
            
            cell.configure(with: item).disposed(by: cell.disposeBag)
            return cell
        })
    }
    
    func layout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .absolute(200)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 4,
                bottom: 0,
                trailing: 4
            )
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1), // Ширина группы равна ширине коллекции
                heightDimension: .absolute(220) // Высота группы равна половине высоты коллекции
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
           
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 12,
                leading: 16,
                bottom: 12,
                trailing: 16
            )
            return section
        }
    }
    
    func mainView() -> UIView {
        let mainView = UIView()
            .backgroundColor(.white)
            
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
            .assign(to: &collection)
            .register(PlantCell.self)
            .backgroundColor(.mainBackGround)
        
        return mainView.add {
            
            
            UIStackView()
                .append {
                    UILabel()
                        .assign(to: &label)
                        .set(fontStyle: .color(.black), .center)
                        .styledText("Мой Сад")
                    
                    
                    
                    UISearchBar()
                        .backgroundColor(.secondaryBackGround)
                        .tintColor(.secondaryBackGround)
                        .assign(to: &searchBar)
                    
                    UIButton()
                        .assign(to: &button)
        //                .backgroundColor(.black)
//                        .image(UIImage(systemName: "camera.fill"))
                        .borderColor(.black)
                        .borderWidth(3)
                        .add({
                            UILabel()
                                .text("Открыть камеру")
                                .centerXAnchor()
                                .verticalAnchor(0)
        //                        .edgesAnchors()
                        })
                        .set(fontStyle: .color(.black))
                        .cornerRadius(12)
                        .heightAnchor(42)
                        .activate()
//                        .horizontalAnchor(5)
//                        .activate()
//                        .topAnchor(50)
//                        .rightAnchor(24)
        //                        .horizontalAnchor(0)
        //                        .bottomAnchor(300)
//                        .sizeAnchor(24)
                    
                    collectionView
                }
                .spacing(20)
                .axis(.vertical)
                .topAnchor(50)
                .horizontalAnchor(0)
                .bottomAnchor(0)
        }
    }
}
