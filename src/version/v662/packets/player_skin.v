module packets

import serializer
import version.v662.types

pub struct PlayerSkinPacket {
pub mut:
	uuid                     types.Uuid
	serialized_skin          types.SerializedSkin
	new_skin_name            string
	old_skin_name            string
	trusted_marketplace_skin bool
}

pub fn (p &PlayerSkinPacket) pid() u16 { return 93 }

pub fn (p &PlayerSkinPacket) name() string { return 'PlayerSkinPacket' }

pub fn (p &PlayerSkinPacket) can_be_sent_before_login() bool { return false }

pub fn (p &PlayerSkinPacket) encode_payload(mut w serializer.Writer) {
	p.uuid.encode(mut w)
	p.serialized_skin.encode(mut w)
	w.write_string(p.new_skin_name)
	w.write_string(p.old_skin_name)
	w.bool(p.trusted_marketplace_skin)
}

pub fn (mut p PlayerSkinPacket) decode_payload(mut r serializer.Reader) ! {
	p.uuid = types.Uuid.decode(mut r)!
	p.serialized_skin = types.SerializedSkin.decode(mut r)!
	p.new_skin_name = r.read_string()!
	p.old_skin_name = r.read_string()!
	p.trusted_marketplace_skin = r.bool()!
}
