//
//  AuthScreenViewModel.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import RxSwift
import RxCocoa
import CoreML
import CoreImage


public final class LoginScreenViewModel: FlowController {
    public enum Event {
        case login
        case changeToSignIn
    }
    public var onComplete: CompletionBlock?
    private let disposeBag = DisposeBag()
    
    private let loginRelay = BehaviorRelay<String?>(value: nil)
    private let passwordRelay = BehaviorRelay<String?>(value: nil)
    private let needShowErrorRelay = BehaviorRelay<Bool>(value: false)
    
    public var isSignInEnabled: Observable<Bool> {
        Observable.combineLatest(loginRelay.asObservable(), passwordRelay.asObservable())
            .map { (username, password) in
                return !(username ?? "").isEmpty && !(password ?? "").isEmpty
            }
    }
    
    private let service: UserService
    
    
    public init(service: UserService) {
        self.service = service
        
        sendImage()
        // Создание экземпляра модели
        

        // Выполнение предсказаний
//        let prediction = try? model?.prediction(input: inputData)
        
    }
    private func sendImage() {
        service.sendImage(data: (UIImage(named: "plantim")?.jpegData(compressionQuality: 1.0))!)
            .subscribe(onSuccess: { response in
                print(response.real_name)
            }).disposed(by: disposeBag)
    }
    
    
    func transformImage(image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else {
                return nil
            }
            
            let context = CIContext(options: nil)
            let ciImage = CIImage(cgImage: cgImage)
            
            let aspectRatio = image.size.width / image.size.height
            
            let resizeFilter = CIFilter(name: "CILanczosScaleTransform")
            resizeFilter?.setValue(ciImage, forKey: kCIInputImageKey)
            resizeFilter?.setValue(aspectRatio, forKey: "inputAspectRatio")
            resizeFilter?.setValue(256.0 / min(image.size.width, image.size.height), forKey: "inputScale")
            
            guard let outputImage = resizeFilter?.outputImage else {
                return nil
            }
            
            guard let cgImageResult = context.createCGImage(outputImage, from: outputImage.extent) else {
                return nil
            }
            
            return UIImage(cgImage: cgImageResult)
    }
    
    func convertToRGB(image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let width = cgImage.width
        let height = cgImage.height
        
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: width * 4,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else {
            return nil
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let outputCGImage = context.makeImage() else {
            return nil
        }
        
        return UIImage(cgImage: outputCGImage)
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Выбор масштаба, чтобы сохранить пропорции
        let newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    private func login() {
//        let resizedImage = resizeImage(image: UIImage(named: "adrinum")!, targetSize: CGSize(width: 256, height: 256))
//        guard let convertededImage = convertToRGB(image: resizedImage) else {
//            print("Ошибка при изменении размера изображения")
//            return
//        }
//
//
//        // Преобразуйте изображение в массив пикселей
//        guard let pixelBuffer = convertededImage.pixelBuffer() else {
//            print("Ошибка при получении буфера пикселей")
//            return
//        }
//
//        // Нормализуйте значения пикселей
//        let mean: Float = 0.5
//        let std: Float = 0.5
//
//        // Создайте MLMultiArray или MLShapedArray
//        let width = CVPixelBufferGetWidth(pixelBuffer)
//        let height = CVPixelBufferGetHeight(pixelBuffer)
//
//        // Создаем MLMultiArray с нужными размерами и типом данных
//        let inputArray = try? MLMultiArray(shape: [1, 3, NSNumber(value: width), NSNumber(value: height)], dataType: .float32)
//        let inputArray = try? MLMultiArray(pixelBuffer: pixelBuffer, asType: .float32)
//        print(inputArray)
//        let inputArray = MLMultiArray(pixelBuffer: pixelBuffer, shape: [1, 3, NSNumber(value: width), NSNumber(value: height)])
        // Нормализуйте значения пикселей и поместите их в MLMultiArray или MLShapedArray
//        for i in 0..<inputArray!.count {
//            inputArray![i] = (inputArray![i].floatValue - mean) / std as NSNumber
//        }
        
//        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
//        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
//
////        let width = CVPixelBufferGetWidth(pixelBuffer)
////        let height = CVPixelBufferGetHeight(pixelBuffer)
////        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)!
//        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
//        guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)?.assumingMemoryBound(to: UInt8.self) else {
//            print("Ошибка при получении адреса базы данных пикселей")
//            return
//        }
//        for y in 0..<height {
//            for x in 0..<width {
//                let offset = 4 * (y * width + x)
//                let blue = Float(baseAddress[offset ]) / 255.0
//                let green = Float(baseAddress[offset + 1]) / 255.0
//                let red = Float(baseAddress[offset + 2]) / 255.0
//
//                inputArray![[0, 0, y, x] as [NSNumber]] = NSNumber(value: red )
//                inputArray![[0, 1, y, x] as [NSNumber]] = NSNumber(value: green )
//                inputArray![[0, 2, y, x] as [NSNumber]] = NSNumber(value: blue )
//
//            }
//        }
//        print(inputArray![[0, 0, 0, 0]])
//        print(inputArray![[0, 0, 0, 1]])
//        print(inputArray![[0, 0, 0, 2]])
//        print(inputArray![[0, 0, 0, 3]])
//        print(inputArray![[0, 1, 0, 0]])
//        print(inputArray![[0, 2, 0, 0]])
//
//        let input = modelForPlantInput(x_1: inputArray!)

        // Создайте экземпляр модели
//        guard let model = try? modelForPlant() else {
//            print("Ошибка при создании экземпляра модели")
//            return
//        }
//
//        // Получите предсказание
//        do {
//            let output = try model.prediction(input: input)
//            // Обработайте результаты предсказания
//            print(output.linear_0)
//
//        } catch {
//            print("Ошибка при получении предсказания: \(error)")
//        }
//        let m = try? modelForPlant()
//        guard let imageData = preprocessImage(image: UIImage(named: "drop")!) else {
//                print("Ошибка при предобработке изображения")
//                return
//            }
//
////        guard let input = try? MLMultiArray(imageData, shape: <#T##[NSNumber]#>)
//        guard let input = try? MLMultiArray(imageData) else {
//                print("Ошибка при преобразовании входных данных")
//                return
//            }
//
//        guard let model = try? modelForPlant(configuration: MLModelConfiguration()) else {
//            print("Ошибка при создании экземпляра модели")
//            return
//        }
//        // Выполняем предсказание
//            do {
//                let output = try m!.prediction(input: modelForPlantInput(x_1: input))
//                // Обрабатываем выходные данные модели
//                print("Выходные данные модели:", output)
//            } catch {
//                print("Ошибка при выполнении предсказания:", error)
//            }
//
        guard let login = loginRelay.value, let password = passwordRelay.value else {
            return
        }
        
        service.login(login: login, password: password)
            .subscribe(
                onCompleted: { [weak self] in
                    self?.complete(.login)
                    UserSettingsStorage.shared.savePassword(value: password)
                    UserSettingsStorage.shared.saveLogin(value: login)
                },
                onError: { [weak self] _ in
                    print(1)
                    print(password)
                    self?.needShowErrorRelay.accept(true)
                })
            .disposed(by: disposeBag)
        
    }
    
    public func updateUsername(_ username: String) {
        loginRelay.accept(username)
    }
    
    public func updatePassword(_ password: String) {
        passwordRelay.accept(password)
    }
}

// MARK: - Биндинги для контроллера
extension LoginScreenViewModel: LoginScreenViewControllerBindings {
    public var needShowError: RxCocoa.Driver<Bool> {
        needShowErrorRelay.asDriver()
    }
    
    public var changeToSignInButtonTapped: RxSwift.Binder<Void> {
        Binder(self) { vm, _ in vm.complete(.changeToSignIn) }
    }
    
    public var loginUpdate: RxSwift.Binder<String> {
        Binder(self) { vm, login in vm.updateUsername(login) }
    }
    
    public var passwordUpdate: RxSwift.Binder<String> {
        Binder(self) { vm, password in vm.updatePassword(password) }
    }
    
    public var loginIsEnabled: RxCocoa.Driver<Bool> {
        isSignInEnabled.asDriver(onErrorJustReturn: false)
    }
    
    public var loginButtonTapped: RxSwift.Binder<Void> {
        Binder(self) { vm, _ in vm.login() }
    }
}
