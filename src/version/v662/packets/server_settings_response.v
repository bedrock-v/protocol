module packets

import protocol.serializer

pub struct ServerSettingsResponsePacket {
pub mut:
	form_id      u32
	form_ui_json string
}

pub fn (p &ServerSettingsResponsePacket) pid() u16 {
	return 103
}

pub fn (p &ServerSettingsResponsePacket) name() string {
	return 'ServerSettingsResponsePacket'
}

pub fn (p &ServerSettingsResponsePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ServerSettingsResponsePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.form_id)
	w.write_string(p.form_ui_json)
}

pub fn (mut p ServerSettingsResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.form_id = r.read_varuint32()!
	p.form_ui_json = r.read_string()!
}
