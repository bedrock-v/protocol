module packets

import serializer
import version.v291.types as types_291
import version.v390.types

pub struct PlayerSkinPacket {
pub mut:
	uuid          types_291.Uuid
	skin          types.SerializedSkin
	new_skin_name string
	old_skin_name string
	trusted_skin  bool
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
	p.skin.encode(mut w)
	w.write_string(p.new_skin_name)
	w.write_string(p.old_skin_name)
	w.bool(p.trusted_skin)
}

pub fn (mut p PlayerSkinPacket) decode_payload(mut r serializer.Reader) ! {
	p.uuid = types_291.Uuid.decode(mut r)!
	p.skin = types.SerializedSkin.decode(mut r)!
	p.new_skin_name = r.read_string()!
	p.old_skin_name = r.read_string()!
	if r.remaining() > 0 {
		p.trusted_skin = r.bool()!
	}
}
