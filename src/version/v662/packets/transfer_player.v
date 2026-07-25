module packets

import serializer

pub struct TransferPlayerPacket {
pub mut:
	server_address string
	server_port    u16
}

pub fn (p &TransferPlayerPacket) pid() u16 { return 85 }

pub fn (p &TransferPlayerPacket) name() string { return 'TransferPlayerPacket' }

pub fn (p &TransferPlayerPacket) can_be_sent_before_login() bool { return false }

pub fn (p &TransferPlayerPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.server_address)
	w.le_u16(p.server_port)
}

pub fn (mut p TransferPlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.server_address = r.read_string()!
	p.server_port = r.le_u16()!
}
