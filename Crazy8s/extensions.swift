
import Foundation

#if os(Linux)
	extension MutableCollection where Index == Int {
		/// Shuffle the elements of `self` in-place.
		mutating func shuffle() {
			// empty and single-element collections don't shuffle
			if count < 2 { return }

			for i in startIndex ..< endIndex - 1 {
				let j = Int(random() % (endIndex - i)) + i
				guard i != j else { continue }
				swap(&self[i], &self[j])
			}
		}
	}
#else
	extension MutableCollectionType where Index == Int {
		/// Shuffle the elements of `self` in-place.
		mutating func shuffle() {
			// empty and single-element collections don't shuffle
			if count < 2 { return }

			for i in startIndex ..< endIndex - 1 {
				let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
				guard i != j else { continue }
				swap(&self[i], &self[j])
			}
		}
	}
#endif