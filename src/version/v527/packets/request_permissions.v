module packets

import serializer
import version.v291.enums as enums_291

pub struct RequestPermissionsPacket {
pub mut:
	unique_entity_id   i64
	permissions        enums_291.PlayerPermission
	custom_permissions u16
}

pub fn (p &RequestPermissionsPacket) pid() u16 {
	return 185
}

pub fn (p &RequestPermissionsPacket) name() string {
	return 'RequestPermissionsPacket'
}

pub fn (p &RequestPermissionsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RequestPermissionsPacket) encode_payload(mut w serializer.Writer) {
	w.le_i64(p.unique_entity_id)
	w.write_varint32(i32(p.permissions))
	w.le_u16(p.custom_permissions)
}

pub fn (mut p RequestPermissionsPacket) decode_payload(mut r serializer.Reader) ! {
	p.unique_entity_id = r.le_i64()!
	p.permissions = unsafe { enums_291.PlayerPermission(u32(r.read_varint32()!)) }
	p.custom_permissions = r.le_u16()!
}
