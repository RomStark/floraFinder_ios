//
//  PlantDetectService.swift
//  floraFinder
//
//  Created by Al Stark on 15.05.2024.
//

import Foundation
import CoreML
import RxCocoa
import RxSwift


public class PlantDetectService {
    static let shared = PlantDetectService()
    private init() { }
    
    func detectPlant(input image: UIImage) -> Single<Int> {
        return Single<Int>.create { [weak self] single in
            guard let model = try? PlantModel() else {
                single(.failure(NSError(domain: "Ошибка при создании экземпляра модели", code: 0, userInfo: nil)))
                return Disposables.create()
            }
            
            do {
                let inputImage = image.pixelBuffer(width: 256, height: 256)!
                let output = try model.prediction(input_image: inputImage)
                
                guard let idx = self?.findMaxIdx(predict: output.linear_0) else {
                    single(.failure(NSError(domain: "Ошибка при получении ответа", code: 0, userInfo: nil)))
                    return Disposables.create()
                }
                single(.success(idx))
                
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    private let russNames: [String] = ["бактериальная гниль", "черная гниль",
                             "здоровая",
                             "фитофтороз",
                             "мозаика",
                             "мучнистая роса",
                             "ржавчина",
                             "пятнистость",
                             "желтуха",]
    
//    func detectDisease(input image: UIImage) -> Int {
//        guard let model = try? DiseaseModel() else {
//            print("Ошибка при создании экземпляра модели")
//            return 0
//        }
//
//        do {
//
//            let inputImage = image.pixelBuffer(width: 400, height: 400)!
//            let output = try model.prediction(input_image: inputImage)
//            // Обработайте результаты предсказания
//
//            let idx = findMaxIdx(predict: output.linear_0)
//            return idx
//            print(output.linear_0)
//
//        } catch {
//            print("Ошибка при получении предсказания: \(error)")
//        }
//        print("model end")
//    }
    
    func detectDisease(input image: UIImage) -> Single<String>  {
        return Single<String>.create { [weak self] single in
            guard let model = try? DiseaseModel() else {
                single(.failure(NSError(domain: "Ошибка при создании экземпляра модели", code: 0, userInfo: nil)))
                return Disposables.create()
            }
            
            do {
                let inputImage = image.pixelBuffer(width: 400, height: 400)!
                let output = try model.prediction(input_image: inputImage)
                guard let idx = self?.findMaxIdx(predict: output.linear_0),
                      let disease = self?.russNames[idx] else {
                    single(.failure(NSError(domain: "Ошибка при получении ответа", code: 0, userInfo: nil)))
                    return Disposables.create()
                }
                single(.success(disease))
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    private func findMaxIdx(predict: MLMultiArray) -> Int {
        var maxIndex = 0
        var maxValue: Float32 = -Float32.infinity
        
        for i in 0..<predict.count {
            if let value = predict[i] as? Float32 {
                if value > maxValue {
                    maxValue = value
                    maxIndex = i
                }
            }
        }
        return maxIndex
    }
}

