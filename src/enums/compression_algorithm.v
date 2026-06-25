module enums

pub enum CompressionAlgorithm as u16 {
	zlib   = 0
	snappy = 1
	none   = 255
}
