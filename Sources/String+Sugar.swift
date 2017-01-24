//
//  String+Sugar.swift
//  Rehatch
//
//  Created by David Roman on 23/01/2017.
//
//

import Foundation

extension String {
	func prompted() -> String {
		return replacingOccurrences(of: ".", with: ":")
	}
}
