module types

import protocol.serializer

pub struct SerializedSkin {
pub mut:
	skin_id       string
	skin_data     []u8
	cape_data     []u8
	geometry_name string
	geometry_data string
	premium       bool
}

pub fn (t SerializedSkin) encode(mut w serializer.Writer) {
	w.write_string(t.skin_id)
	w.write_string_bytes(t.skin_data)
	w.write_string_bytes(t.cape_data)
	w.write_string(t.geometry_name)
	w.write_string(t.geometry_data)
}

pub fn SerializedSkin.decode(mut r serializer.Reader) !SerializedSkin {
	return SerializedSkin{
		skin_id:       r.read_string()!
		skin_data:     r.read_string_bytes()!
		cape_data:     r.read_string_bytes()!
		geometry_name: r.read_string()!
		geometry_data: r.read_string()!
	}
}
