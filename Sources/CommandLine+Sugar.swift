//
//  CommandLine+Sugar.swift
//  Rehatch
//
//  Created by David Román Aguirre on 23/01/2017.
//
//

import Foundation
import CommandLineKit

extension CommandLineKit.CommandLine {
	convenience init(arguments: [String]? = nil, options: Option...) {
		if let arguments = arguments {
			self.init(arguments: arguments)
		} else {
			self.init()
		}
		addOptions(options)
	}
}
