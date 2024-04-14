//
//  KingFisherImageLoader.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import Kingfisher
import RxSwift

public struct KingfisherImageLoader {
    public init() {}
    
    public func load(url: String?) -> Single<UIImage?> {
        guard let urlString = url, let url = URL(string: urlString) else {
            return .just(nil)
        }

        return Single.create { observer in
            let imageView = UIImageView()
            imageView.kf.setImage(with: url, completionHandler: { result in
                switch result {
                case .success(let value):
                    observer(.success(value.image))
                case .failure(let error):
                    observer(.success(UIImage(named: "not-image")))
                }
            })
            return Disposables.create()
        }
    }
}
