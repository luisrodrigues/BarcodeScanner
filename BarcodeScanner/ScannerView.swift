//
//  ScannerView.swift
//  BarcodeScanner
//
//  Created by Rodrigues, Luis on 24/12/2022.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
	
	func makeUIViewController(context: Context) -> ScannerVC {
		ScannerVC(scannerDelegate: context.coordinator)
	}
	
	func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {}
	
	func makeCoordinator() -> Coordinator {
		Coordinator()
	}
	
	final class Coordinator: NSObject, ScannerVCDelegate {
		func didFind(barcode: String) {
			print(barcode)
		}
		
		func didSurface(error: CameraError) {
			print(error.rawValue)
		}
	}
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
