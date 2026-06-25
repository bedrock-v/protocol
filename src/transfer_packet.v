module src

import src.serializer

pub struct TransferPacket {
pub mut:
	address      string
	port         int
	reload_world bool
}

pub fn (p &TransferPacket) pid() u16 {
	return transfer_packet
}

pub fn (p &TransferPacket) name() string {
	return 'TransferPacket'
}

pub fn (p &TransferPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p TransferPacket) decode_payload(mut r serializer.Reader) ! {
	p.address = r.read_string()!
	p.port = int(r.le_u16()!)
	p.reload_world = r.bool()!
}

pub fn (p &TransferPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.address)
	w.le_u16(u16(p.port))
	w.bool(p.reload_world)
}
