//
//  DrugsListViewController.swift
//  floraFinder
//
//  Created by Al Stark on 16.05.2024.
//

import DeclarativeLayoutKit
import RxDataSources
import RxSwift
import RxCocoa


public protocol DrugsListViewControllerBindings {
    var drugsCells: Driver<[DrugsSectionModel]> { get }
}

public final class DrugsListViewController: ViewController {
    private weak var collection: UICollectionView!
    
    public override func loadView() {
        view = mainView()
    }
    
    public func bind(to bindings: DrugsListViewControllerBindings) -> Disposable {
        return [
            bindings.drugsCells.drive(collection.rx.items(dataSource: dataSource())),
        ]
    }
}

private extension DrugsListViewController {
    func dataSource() -> DrugsRxDataSource {
        DrugsRxDataSource(configureCell: { _, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DrugCell.self), for: indexPath) as! DrugCell
            
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
            .register(DrugCell.self)
            .backgroundColor(.mainBackGround)
        
        return mainView.add {
            UIStackView()
                .append {
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
