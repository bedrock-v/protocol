module enums

import protocol.serializer

pub enum SerializedAbilitiesLayer as u16 {
	custom_cache = 0
	base         = 1
	spectator    = 2
	commands     = 3
	editor       = 4
}

pub fn (e SerializedAbilitiesLayer) encode(mut w serializer.Writer) {
	w.le_u16(u16(e))
}

pub fn SerializedAbilitiesLayer.decode(mut r serializer.Reader) !SerializedAbilitiesLayer {
	return unsafe { SerializedAbilitiesLayer(r.le_u16()!) }
}
