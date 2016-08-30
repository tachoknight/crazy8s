
import Foundation

extension MutableCollectionType where Index == Int {
	/// Shuffle the elements of `self` in-place.
	mutating func shuffle() {
		// empty and single-element collections don't shuffle
		if count < 2 { return }

		for i in startIndex ..< endIndex - 1 {
			#if os(Linux)
				let j = Int(random() % (endIndex - i)) + i
			#else
				let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
			#endif
			guard i != j else { continue }
			swap(&self[i], &self[j])
		}
	}
}