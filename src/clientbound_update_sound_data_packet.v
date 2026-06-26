module src

import src.serializer

pub struct ClientboundUpdateSoundDataPacket {
pub mut:
	server_sound_handle u64
	sound_event         string
}

pub fn (p &ClientboundUpdateSoundDataPacket) pid() u16 {
	return clientbound_update_sound_data_packet
}

pub fn (p &ClientboundUpdateSoundDataPacket) name() string {
	return 'ClientboundUpdateSoundDataPacket'
}

pub fn (p &ClientboundUpdateSoundDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ClientboundUpdateSoundDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.server_sound_handle = r.le_u64()!
	p.sound_event = r.read_string()!
}

pub fn (p &ClientboundUpdateSoundDataPacket) encode_payload(mut w serializer.Writer) {
	w.le_u64(p.server_sound_handle)
	w.write_string(p.sound_event)
}
