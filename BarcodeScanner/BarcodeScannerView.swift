//
//  BarcodeScannerView.swift
//  BarcodeScanner
//
//  Created by Rodrigues, Luis on 23/12/2022.
//

import SwiftUI

struct AlertItem: Identifiable {
	let id = UUID()
	let title: String
	let message: String
	let dismissButton: Alert.Button
}

struct AlertContext {
	static let invalidDeviceInput = AlertItem(title: "Invalid device input", message: "Something is wrong with the camera. Unable to capture the input.", dismissButton: .default(Text("Ok")))
	
	static let invalidScannedType = AlertItem(title: "Invalid scan type", message: "The scanned value is not valid. Supported values: EAN-8 and EAN-13.", dismissButton: .default(Text("Ok")))
										
}

struct BarcodeScannerView: View {
	
	@State private var scannedCode = ""
	@State private var alertItem: AlertItem?
	
    var body: some View {
        NavigationView {
			VStack {
				ScannerView(scannedCode: $scannedCode, alertItem: $alertItem)
					.frame(maxWidth: .infinity, maxHeight: 300)
				
				Spacer().frame(height: 60)
				
				Label("Scanned barcode:", systemImage: "barcode.viewfinder")
					.font(.title)
				
				Text(scannedCode.isEmpty ? "Not yet scanned" : scannedCode)
					.bold()
					.font(.largeTitle)
					.foregroundColor(scannedCode.isEmpty ? .red : .green)
					.padding()
			}
			.navigationTitle("Barcode Scanner")
			.alert(item: $alertItem) { alertItem in
				Alert(title: Text(alertItem.title), message: Text(alertItem.message), dismissButton: alertItem.dismissButton)
			}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
    }
}
