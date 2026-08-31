module packets

import protocol.serializer
import protocol.version.v137.types

pub struct PlayerSkinPacket {
pub mut:
	uuid           types.Uuid
	skin_id        string
	skin_name      string
	serialize_name string
	skin_data      string
	cape_data      string
	geometry_model string
	geometry_data  string
}

pub fn (p &PlayerSkinPacket) pid() u16 {
	return 93
}

pub fn (p &PlayerSkinPacket) name() string {
	return 'PlayerSkinPacket'
}

pub fn (p &PlayerSkinPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerSkinPacket) encode_payload(mut w serializer.Writer) {
	p.uuid.encode(mut w)
	w.write_string(p.skin_id)
	w.write_string(p.skin_name)
	w.write_string(p.serialize_name)
	w.write_string(p.skin_data)
	w.write_string(p.cape_data)
	w.write_string(p.geometry_model)
	w.write_string(p.geometry_data)
}

pub fn (mut p PlayerSkinPacket) decode_payload(mut r serializer.Reader) ! {
	p.uuid = types.Uuid.decode(mut r)!
	p.skin_id = r.read_string()!
	p.skin_name = r.read_string()!
	p.serialize_name = r.read_string()!
	p.skin_data = r.read_string()!
	p.cape_data = r.read_string()!
	p.geometry_model = r.read_string()!
	p.geometry_data = r.read_string()!
}
