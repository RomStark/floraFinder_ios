//
//  PlantByPhotoViewController.swift
//  floraFinder
//
//  Created by Al Stark on 15.04.2024.
//


import DeclarativeLayoutKit
import RxDataSources
import RxSwift
import RxCocoa
import AVFoundation


public protocol PlantByPhotoViewControllerBindings {
    var makePhotoTapped: Binder<UIImage?> { get }
}

public final class PlantByPhotoViewController: ViewController {
    private weak var videoView: UIView!
    private let session = AVCaptureSession()
    private var video = AVCaptureVideoPreviewLayer()
    private weak var makePhotoButton: UIButton!
    private var photoOutput = AVCapturePhotoOutput()
    private let imageRelay = BehaviorRelay<UIImage?>(value: nil)
    
    public override func loadView() {
        view = UIView().backgroundColor(.white)
        view.add({
            setupCamera()
                .assign(to: &videoView)
                .horizontalAnchor(0)
                .topAnchor(view.topAnchor)
                .bottomAnchor(view.bottomAnchor)
            
            UIButton()
                .assign(to: &makePhotoButton)
                .onTap({ [weak self] in
                    self?.capturePhoto()
                })
                .backgroundColor(.white)
                .cornerRadius(30)
                .sizeAnchor(60)
                .centerXAnchor()
                .bottomAnchor(120)
        })
        
        startRunning()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        video.frame = videoView.layer.bounds
        
    }
    
    public func bind(to bindings: PlantByPhotoViewControllerBindings) -> Disposable {
        return [
            imageRelay.bind(to: bindings.makePhotoTapped),
        ]
    }
}

private extension PlantByPhotoViewController {
    private func capturePhoto() {
//        guard let photoOutput = self.photoOutput else { return }

        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = .auto // You can set flash mode if needed

        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    private func setupCamera() -> UIView {
        let videoView = UIView()
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            print("LHljhljhljhkh")
        }
        session.addOutput(photoOutput)
        

        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = videoView.layer.bounds
        
        return videoView
    }
    
    func startRunning() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            //            self.video.frame = self.videoView.layer.bounds
            self.videoView.layer.addSublayer(self.video)
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else { return }
                self.session.startRunning()
            }
        }
    }
    
    
    func mainView() -> UIView {
        let mainView = UIView()
            .backgroundColor(.mainBackGround)
        
        
        
        return mainView.add {
            
        }
    }
}

extension PlantByPhotoViewController: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
            print("Error capturing photo: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        print("image sdelali")
        print(image.description)
        // Display captured image
        imageRelay.accept(image)
    }
}
