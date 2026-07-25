module packets

import serializer

pub struct TransferPacket {
pub mut:
	address string
	port    i16
}

pub fn (p &TransferPacket) pid() u16 {
	return 0x56
}

pub fn (p &TransferPacket) name() string {
	return 'TransferPacket'
}

pub fn (p &TransferPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &TransferPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.address)
	w.le_i16(p.port)
}

pub fn (mut p TransferPacket) decode_payload(mut r serializer.Reader) ! {
	p.address = r.read_string()!
	p.port = r.le_i16()!
}
