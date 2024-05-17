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
    var tapCamera: Binder<Void> { get }
    var tapLogOut: Binder<Void> { get }
    var tapDrugs: Binder<Void> { get }
}

public final class MainScreenViewController: ViewController {
    private weak var label: UILabel!
    private weak var collection: UICollectionView!
    private weak var openAllPlantsList: Button!
    private weak var openDiseaseButton: Button!
    private weak var logOutButton: LogOutButton!
    private weak var drugsListButton: DrugsListButton!
    
    
    public override func loadView() {
        view = mainView()
        configureNavigationBarItems()
        
    }
    
    public func bind(to bindings: MainScreenViewControllerBindings) -> Disposable {
        return [
            bindings.plantsCells.drive(collection.rx.items(dataSource: dataSource())),
            openAllPlantsList.rx.tap.bind(to: bindings.openAllPlantsList),
            openDiseaseButton.rx.tap.bind(to: bindings.tapCamera),
            logOutButton.rxTap.bind(to: bindings.tapLogOut),
            drugsListButton.rxTap.bind(to: bindings.tapDrugs)
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
    
    private func configureNavigationBarItems() {
        
        let logOutButton = LogOutButton()
            .assign(to: &logOutButton)
            .asBarButtonItem()
        
        let drugsListButton = DrugsListButton()
            .assign(to: &drugsListButton)
            .asBarButtonItem()
        
        
        navigationItem.leftBarButtonItem = drugsListButton
        navigationItem.rightBarButtonItem = logOutButton
//        navigationItem.rightBarButtonItems = [notificationsButton, promosButton]
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
//                    UIStackView()
//                        .axis(.horizontal)
//                        .spacing(20)
//                        .append({
//
//                            Button()
//                                .assign(to: &settingsButton)
//                                .onTap {
//                                    print(1)
//                                }
//                                .image(UIImage(systemName: "gearshape"))
//
//                            UILabel()
//                                .assign(to: &label)
//                                .set(fontStyle: .color(.black), .center)
//                                .styledText("Мой Сад")
//
//                        })
                    
                    Button()
                        .assign(to: &openDiseaseButton)
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
                    
                    
                    collectionView
                }
                .spacing(30)
                .axis(.vertical)
                .topAnchor(10.from(mainView.safeAreaLayoutGuide.topAnchor))
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

public final class LogOutButton: UIView {
    private weak var button: UIButton!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        add({
            UIView()
                .backgroundColor(.mainBackGround)
                .cornerRadius(16)
                .add({
                    UIImageView()
                        .image(UIImage(systemName: "rectangle.portrait.and.arrow.right"))
                        .contentMode(.center)
                        .clipsToBounds(true)
                        .sizeAnchor(20)
                        .edgesAnchors()
                })
                .sizeAnchor(32)
                .edgesAnchors()
            
            UIButton()
                .assign(to: &button)
                .edgesAnchors()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var rxTap: ControlEvent<Void> {
        button.rx.tap
    }
}

public final class DrugsListButton: UIView {
    private weak var button: UIButton!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        add({
            UIView()
                .backgroundColor(.mainBackGround)
                .cornerRadius(16)
                .add({
                    UIImageView()
                        .image(UIImage(systemName: "bag"))
                        .contentMode(.center)
                        .clipsToBounds(true)
                        .sizeAnchor(20)
                        .edgesAnchors()
                })
                .sizeAnchor(32)
                .edgesAnchors()
            
            UIButton()
                .assign(to: &button)
                .edgesAnchors()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var rxTap: ControlEvent<Void> {
        button.rx.tap
    }
}
