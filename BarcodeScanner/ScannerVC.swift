//
//  ScannerVC.swift
//  BarcodeScanner
//
//  Created by Rodrigues, Luis on 23/12/2022.
//

import UIKit
import AVFoundation

enum CameraError: String {
	case invalidDeviceInput = "Something is wrong with the camera. Unable to capture the input."
	case invalidScannedValue = "The scanned value is not valid. Supported values: EAN-8 and EAN-13."
}

protocol ScannerVCDelegate: AnyObject {
	func didFind(barcode: String)
	func didSurface(error: CameraError)
}

final class ScannerVC: UIViewController {
	
	let captureSession = AVCaptureSession()
	var previewLayer: AVCaptureVideoPreviewLayer?
	weak var scannerDelegate: ScannerVCDelegate?
	
	init(scannerDelegate: ScannerVCDelegate) {
		super.init(nibName: nil, bundle: nil)
		self.scannerDelegate = scannerDelegate
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented yet") }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupCaptureSesssion()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		guard let previewLayer = previewLayer else {
			scannerDelegate?.didSurface(error: .invalidDeviceInput)
			return
		}
		
		previewLayer.frame = view.layer.bounds
	}
	
	private func setupCaptureSesssion() {
		guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
			scannerDelegate?.didSurface(error: .invalidDeviceInput)
			return
		}
		
		let videoInput: AVCaptureDeviceInput
		
		do {
			try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
		} catch {
			scannerDelegate?.didSurface(error: .invalidDeviceInput)
			return
		}
		
		if captureSession.canAddInput(videoInput) {
			captureSession.addInput(videoInput)
		} else {
			scannerDelegate?.didSurface(error: .invalidDeviceInput)
			return
		}
		
		let metadataOutput = AVCaptureMetadataOutput()
		if captureSession.canAddOutput(metadataOutput) {
			captureSession.addOutput(metadataOutput)
			metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			metadataOutput.metadataObjectTypes = [.ean8, .ean13]
		} else {
			scannerDelegate?.didSurface(error: .invalidDeviceInput)
			return
		}
		
		previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer!.videoGravity = .resizeAspectFill
		view.layer.addSublayer(previewLayer!)
		
		captureSession.startRunning()
	}
}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		guard let object = metadataObjects.first else {
			scannerDelegate?.didSurface(error: .invalidScannedValue)
			return
		}
		
		guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
			scannerDelegate?.didSurface(error: .invalidScannedValue)
			return
		}
		
		guard let barcode = machineReadableObject.stringValue else {
			scannerDelegate?.didSurface(error: .invalidScannedValue)
			return
		}
		
		scannerDelegate?.didFind(barcode: barcode)
	}
}
