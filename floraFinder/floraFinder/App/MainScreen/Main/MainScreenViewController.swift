//
//  MainScreenViewController.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//


import DeclarativeLayoutKit
import RxDataSources
import RxSwift
import RxCocoa


public protocol MainScreenViewControllerBindings {
    var plantsCells: Driver<[UserPlantSectionModel]> { get }
    var openAllPlantsList: Binder<Void> { get }
}

public final class MainScreenViewController: ViewController {
    private weak var label: UILabel!
    private weak var collection: UICollectionView!
    private weak var openAllPlantsList: Button!
    
    public override func loadView() {
        view = mainView()
    }
    
    public func bind(to bindings: MainScreenViewControllerBindings) -> Disposable {
        return [
            bindings.plantsCells.drive(collection.rx.items(dataSource: dataSource())),
            openAllPlantsList.rx.tap.bind(to: bindings.openAllPlantsList)
            
        ]
    }

}

private extension MainScreenViewController {
    func dataSource() -> UserPlantsRxDataSource {
        UserPlantsRxDataSource(configureCell: { _, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UserPlantCell.self), for: indexPath) as! UserPlantCell
            
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
            .register(UserPlantCell.self)
            .backgroundColor(.secondaryBackGround)
        
        return mainView.add {
            UIStackView()
                .append {
                    UIStackView()
                        .axis(.horizontal)
                        .spacing(20)
                        .append({
                            UIView()
                                .sizeAnchor(20)
                            UIButton()
                                .backgroundColor(.red)
                                .sizeAnchor(24)
                                .activate()
                            
                            UILabel()
                                .assign(to: &label)
                                .set(fontStyle: .color(.black), .center)
                                .styledText("Мой Сад")
                            
                            UIButton()
                                .backgroundColor(.red)
                                .sizeAnchor(24)
                                .activate()
                            UIView()
                                .sizeAnchor(20)
                        })
                        
                    collectionView
                }
                .spacing(30)
                .axis(.vertical)
                .topAnchor(50)
                .horizontalAnchor(0)
                .bottomAnchor(0)
            
            Button()
                .assign(to: &openAllPlantsList)
                .image(UIImage(named: "plus"))
                .imageContentMode(.scaleAspectFit)
                .sizeAnchor(60)
                .horizontalAnchor(120)
                .bottomAnchor(120.from(mainView.safeAreaLayoutGuide.bottomAnchor))
        }
    }
}
