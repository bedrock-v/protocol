module src

import src.serializer
import src.types

pub struct PlayerSkinPacket {
pub mut:
	uuid          types.UUID
	skin          types.SkinData
	new_skin_name string
	old_skin_name string
	verified      bool
}

pub fn (p &PlayerSkinPacket) pid() u16 {
	return player_skin_packet
}

pub fn (p &PlayerSkinPacket) name() string {
	return 'PlayerSkinPacket'
}

pub fn (p &PlayerSkinPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PlayerSkinPacket) decode_payload(mut r serializer.Reader) ! {
	p.uuid = r.read_uuid()!
	p.skin = r.read_skin()!
	p.new_skin_name = r.read_string()!
	p.old_skin_name = r.read_string()!
	p.verified = r.bool()!
}

pub fn (p &PlayerSkinPacket) encode_payload(mut w serializer.Writer) {
	w.write_uuid(p.uuid)
	w.write_skin(p.skin)
	w.write_string(p.new_skin_name)
	w.write_string(p.old_skin_name)
	w.bool(p.verified)
}
