module src

import src.serializer

pub struct ServerSettingsResponsePacket {
pub mut:
	form_id   int
	form_data string
}

pub fn (p &ServerSettingsResponsePacket) pid() u16 {
	return server_settings_response_packet
}

pub fn (p &ServerSettingsResponsePacket) name() string {
	return 'ServerSettingsResponsePacket'
}

pub fn (p &ServerSettingsResponsePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ServerSettingsResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.form_id = int(r.read_varuint32()!)
	p.form_data = r.read_string()!
}

pub fn (p &ServerSettingsResponsePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.form_id))
	w.write_string(p.form_data)
}
