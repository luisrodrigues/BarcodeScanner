//
//  BarcodeScannerViewModel.swift
//  BarcodeScanner
//
//  Created by Rodrigues, Luis on 25/12/2022.
//

import SwiftUI

final class BarcodeScannerViewModel: ObservableObject {
	@Published var scannedCode = ""
	@Published var alertItem: AlertItem?
	
	var statusText: String {
		scannedCode.isEmpty ? "Not yet scanned" : scannedCode
	}
	
	var statusTextColor: Color {
		scannedCode.isEmpty ? .red : .green
	}
}
