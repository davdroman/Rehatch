//
//  Array+SafeIndex.swift
//  Rehatch
//
//  Created by David Roman on 06/07/2017.
//
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {

	/// Returns the element at the specified index iff it is within bounds, otherwise nil.
	subscript (safe index: Index) -> Generator.Element? {
		return indices.contains(index) ? self[index] : nil
	}
}
