//
//  SimpleCameraController.swift
//  SimpleCamera
//
//  Created by Simon Ng on 16/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import TesseractOCR

class CameraOCRViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, G8TesseractDelegate {
    
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var txtLbl: UITextView!
    
    var backFacingCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice!
    
    var stillImageOutput: AVCapturePhotoOutput!
    var stillImage: UIImage?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    let captureSession = AVCaptureSession()
    
    var toggleCameraGestureRecognizer = UISwipeGestureRecognizer()
    var zoomInGestureRecognizer = UISwipeGestureRecognizer()
    var zoomOutGestureRecognizer = UISwipeGestureRecognizer()
    
    var requests = [VNRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        txtLbl.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func regonizeOCR(img: UIImage) -> String{
        if let tesseract = G8Tesseract(language:"eng"){
            tesseract.delegate = self
            tesseract.image = img.g8_blackAndWhite()
            tesseract.recognize()
            return tesseract.recognizedText
        }else{
            return "noa"
        }
    }

    // MARK: - Action methods
    
    @IBAction func capture(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.title = "Processing"
        cameraButton.isHidden = true
        // Set photo settings
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        stillImageOutput.isHighResolutionCaptureEnabled = true
        stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    // MARK: - Helper methods
    
    private func configure() {
        // Preset the session for taking photo in full resolution
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        // Get the front and back-facing camera for taking photos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        
        for device in deviceDiscoverySession.devices {
            if device.position == .back {
                backFacingCamera = device
            } else if device.position == .front {
                frontFacingCamera = device
            }
        }
        
        currentDevice = backFacingCamera
        
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: currentDevice) else {
            return
        }
        
        // Configure the session with the output for capturing still images
        stillImageOutput = AVCapturePhotoOutput()
        
        // Configure the session with the input and the output devices
        captureSession.addInput(captureDeviceInput)
        captureSession.addOutput(stillImageOutput)
        
        // Provide a camera preview
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.frame = imageView.layer.frame
        
        
        // Bring the camera button to front
        view.bringSubview(toFront: cameraButton)
        captureSession.startRunning()
        
        // Toggle Camera recognizer
        toggleCameraGestureRecognizer.direction = .up
        toggleCameraGestureRecognizer.addTarget(self, action: #selector(toggleCamera))
        view.addGestureRecognizer(toggleCameraGestureRecognizer)
        
        // Zoom In recognizer
        zoomInGestureRecognizer.direction = .right
        zoomInGestureRecognizer.addTarget(self, action: #selector(zoomIn))
        view.addGestureRecognizer(zoomInGestureRecognizer)
        
        // Zoom Out recognizer
        zoomOutGestureRecognizer.direction = .left
        zoomOutGestureRecognizer.addTarget(self, action: #selector(zoomOut))
        view.addGestureRecognizer(zoomOutGestureRecognizer)
    }
    
    @objc func toggleCamera() {
        captureSession.beginConfiguration()
        
        // Change the device based on the current camera
        guard let newDevice = (currentDevice?.position == AVCaptureDevice.Position.back) ? frontFacingCamera : backFacingCamera else {
            return
        }
        
        // Remove all inputs from the session
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        // Change to the new input
        let cameraInput:AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice)
        } catch {
            print(error)
            return
        }
        
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        
        currentDevice = newDevice
        captureSession.commitConfiguration()
    }
    
    @objc func zoomIn() {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            if zoomFactor < 5.0 {
                let newZoomFactor = min(zoomFactor + 1.0, 5.0)
                do {
                    try currentDevice?.lockForConfiguration()
                    currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentDevice?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @objc func zoomOut() {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            if zoomFactor > 1.0 {
                let newZoomFactor = max(zoomFactor - 1.0, 1.0)
                do {
                    try currentDevice?.lockForConfiguration()
                    currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentDevice?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.navigationController?.navigationBar.isHidden)!{
            self.navigationController?.navigationBar.isHidden = false
        }else{
            self.navigationController?.navigationBar.isHidden = true
        }
    }
}

extension CameraOCRViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        imageView.isHidden = true
        captureSession.stopRunning()
        
        guard error == nil else {
            print("error")
            return
        }
        
        
        // Get the image from the photo buffer
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        
        stillImage = UIImage(data: imageData)

        do{
            try MSOCR().recognizeCharactersWithRequestObject((UIImageJPEGRepresentation(stillImage!, 0.3) as Any, MSOCR.Langunages.English, true)) { (result) in
                self.txtLbl.text = MSOCR().extractStringFromDictionary(result!)
                print(self.txtLbl.text)
                self.cameraPreviewLayer?.removeFromSuperlayer()
                self.txtLbl.isHidden = false
                self.navigationController?.navigationBar.isHidden = false
                self.navigationController?.title = "Finished"
            }
        }catch{
            print("error")
        }
        
        /* For TesseractOCR
        let a = regonizeOCR(img: stillImage!)
        print(a)
        txtLbl.text = a
        cameraPreviewLayer?.removeFromSuperlayer()
        txtLbl.isHidden = false
        */
        
    }
}
