//
//  OCRViewController.swift
//  KLPlatform
//
//  Created by KL on 30/3/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class OCRViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate{
  
  @IBOutlet var imageView: UIImageView!
  var session = AVCaptureSession()
  var imagePicker: UIImagePickerController!
  var requests = [VNRequest]()
  var backFacingCamera: AVCaptureDevice?
  var frontFacingCamera: AVCaptureDevice?
  var currentDevice: AVCaptureDevice!
  var stillImageOutput: AVCapturePhotoOutput!
  var stillImage: UIImage?
  let captureSession = AVCaptureSession()
  
  
  func startTextDetection() {
    let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
    textRequest.reportCharacterBoxes = true
    self.requests = [textRequest]
  }
  
  func detectTextHandler(request: VNRequest, error: Error?) {
    guard let observations = request.results else {
      print("no result")
      return
    }
    
    let result = observations.map({$0 as? VNTextObservation})
    
    DispatchQueue.main.async() {
      self.imageView.layer.sublayers?.removeSubrange(1...)
      for region in result {
        guard let rg = region else {
          continue
        }
        
        self.highlightWord(box: rg)
        
        if let boxes = region?.characterBoxes {
          for characterBox in boxes {
            self.highlightLetters(box: characterBox)
          }
        }
      }
    }
  }
  
  func startLiveVideo() {
    session.sessionPreset = AVCaptureSession.Preset.photo
    let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
    
    let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
    let deviceOutput = AVCaptureVideoDataOutput()
    deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
    deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
    session.addInput(deviceInput)
    session.addOutput(deviceOutput)
    
    let imageLayer = AVCaptureVideoPreviewLayer(session: session)
    
    imageLayer.frame = imageView.bounds
    imageView.layer.addSublayer(imageLayer)
    
    session.startRunning()
  }
  
  func highlightWord(box: VNTextObservation) {
    guard let boxes = box.characterBoxes else {
      return
    }
    
    var maxX: CGFloat = 9999.0
    var minX: CGFloat = 0.0
    var maxY: CGFloat = 9999.0
    var minY: CGFloat = 0.0
    
    for char in boxes {
      if char.bottomLeft.x < maxX {
        maxX = char.bottomLeft.x
      }
      if char.bottomRight.x > minX {
        minX = char.bottomRight.x
      }
      if char.bottomRight.y < maxY {
        maxY = char.bottomRight.y
      }
      if char.topRight.y > minY {
        minY = char.topRight.y
      }
    }
    
    let xCord = maxX * imageView.frame.size.width
    let yCord = (1 - minY) * imageView.frame.size.height
    let width = (minX - maxX) * imageView.frame.size.width
    let height = (minY - maxY) * imageView.frame.size.height
    
    let outline = CALayer()
    outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
    outline.borderWidth = 2.0
    outline.borderColor = UIColor.red.cgColor
    
    imageView.layer.addSublayer(outline)
  }
  
  func highlightLetters(box: VNRectangleObservation) {
    let xCord = box.topLeft.x * imageView.frame.size.width
    let yCord = (1 - box.topLeft.y) * imageView.frame.size.height
    let width = (box.topRight.x - box.bottomLeft.x) * imageView.frame.size.width
    let height = (box.topLeft.y - box.bottomLeft.y) * imageView.frame.size.height
    
    let outline = CALayer()
    outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
    outline.borderWidth = 1.0
    outline.borderColor = UIColor.blue.cgColor
    
    imageView.layer.addSublayer(outline)
  }
  
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      return
    }
    
    var requestOptions:[VNImageOption : Any] = [:]
    
    if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
      requestOptions = [.cameraIntrinsics:camData]
    }
    
    let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: requestOptions)
    
    do {
      try imageRequestHandler.perform(self.requests)
    } catch {
      print(error)
    }
  }
  
  override func viewDidLayoutSubviews() {
    imageView.layer.sublayers?[0].frame = imageView.bounds
  }
  
  func configure(){
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
    
    captureSession.startRunning()
  }
  
  @IBAction func test(_ sender: Any) {
    let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
    photoSettings.isAutoStillImageStabilizationEnabled = true
    photoSettings.isHighResolutionPhotoEnabled = true
    photoSettings.flashMode = .auto
    
    stillImageOutput.isHighResolutionCaptureEnabled = true
    stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    startLiveVideo()
    startTextDetection()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
}

extension OCRViewController: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    captureSession.stopRunning()
    session.stopRunning()
    
    guard error == nil else {
      return
    }
    
    // Get the image from the photo buffer
    guard let imageData = photo.fileDataRepresentation() else {
      return
    }
    
    stillImage = UIImage(data: imageData)
  }
}
