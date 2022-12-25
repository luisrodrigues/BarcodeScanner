//
//  Alert.swift
//  BarcodeScanner
//
//  Created by Rodrigues, Luis on 25/12/2022.
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
