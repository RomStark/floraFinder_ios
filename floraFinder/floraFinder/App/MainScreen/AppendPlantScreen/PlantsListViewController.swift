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
}

public final class PlantsListViewController: ViewController {
    private weak var label: UILabel!
    private weak var collection: UICollectionView!
    
    public override func loadView() {
        view = mainView()
    }
    
    public func bind(to bindings: PlantsListViewControllerBindings) -> Disposable {
        return [
            bindings.plantsCells.drive(collection.rx.items(dataSource: dataSource()))
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
            .backgroundColor(.mainBackGround)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
            .assign(to: &collection)
            .register(PlantCell.self)
            .backgroundColor(.secondaryBackGround)
        
        return mainView.add {
            UIStackView()
                .append {
                    UILabel()
                        .assign(to: &label)
                        .set(fontStyle: .color(.black), .center)
                        .styledText("Мой Сад")
                    collectionView
                }
                .spacing(30)
                .axis(.vertical)
                .topAnchor(50)
                .horizontalAnchor(0)
                .bottomAnchor(0)
        }
    }
}
