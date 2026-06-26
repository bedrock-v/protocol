module src

import src.serializer

pub struct ClientboundDataDrivenUIReloadPacket {
}

pub fn (p &ClientboundDataDrivenUIReloadPacket) pid() u16 {
	return clientbound_data_driven_ui_reload_packet
}

pub fn (p &ClientboundDataDrivenUIReloadPacket) name() string {
	return 'ClientboundDataDrivenUIReloadPacket'
}

pub fn (p &ClientboundDataDrivenUIReloadPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ClientboundDataDrivenUIReloadPacket) decode_payload(mut r serializer.Reader) ! {
}

pub fn (p &ClientboundDataDrivenUIReloadPacket) encode_payload(mut w serializer.Writer) {
}
