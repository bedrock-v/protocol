module packets

import protocol.serializer
import protocol.version.v291.types

pub struct PlayerSkinPacket {
pub mut:
	uuid          types.Uuid
	skin          types.SerializedSkin
	new_skin_name string
	old_skin_name string
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
	w.write_string(p.skin.skin_id)
	w.write_string(p.new_skin_name)
	w.write_string(p.old_skin_name)
	w.write_string_bytes(p.skin.skin_data)
	w.write_string_bytes(p.skin.cape_data)
	w.write_string(p.skin.geometry_name)
	w.write_string(p.skin.geometry_data)
	w.bool(p.skin.premium)
}

pub fn (mut p PlayerSkinPacket) decode_payload(mut r serializer.Reader) ! {
	p.uuid = types.Uuid.decode(mut r)!
	p.skin.skin_id = r.read_string()!
	p.new_skin_name = r.read_string()!
	p.old_skin_name = r.read_string()!
	p.skin.skin_data = r.read_string_bytes()!
	p.skin.cape_data = r.read_string_bytes()!
	p.skin.geometry_name = r.read_string()!
	p.skin.geometry_data = r.read_string()!
	p.skin.premium = r.bool()!
}
