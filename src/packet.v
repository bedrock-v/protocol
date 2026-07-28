module protocol

import protocol.serializer

pub const pid_mask = u32(0x3ff)
pub const subclient_id_mask = u32(0x03)
pub const sender_subclient_id_shift = u32(10)
pub const recipient_subclient_id_shift = u32(12)

pub interface Packet {
	pid() u16
	name() string
	can_be_sent_before_login() bool
	encode_payload(mut w serializer.Writer)
mut:
	decode_payload(mut r serializer.Reader) !
}

pub fn write_packet_header(mut w serializer.Writer, pid u16, sender_sub_id u8, recipient_sub_id u8) {
	header := u32(pid) | (u32(sender_sub_id) << sender_subclient_id_shift) | (u32(recipient_sub_id) << recipient_subclient_id_shift)
	w.write_varuint32(header)
}

pub struct DecodedHeader {
pub:
	pid              u16
	sender_sub_id    u8
	recipient_sub_id u8
}

pub fn read_packet_header(mut r serializer.Reader) !DecodedHeader {
	header := r.read_varuint32()!
	return DecodedHeader{
		pid:              u16(header & pid_mask)
		sender_sub_id:    u8((header >> sender_subclient_id_shift) & subclient_id_mask)
		recipient_sub_id: u8((header >> recipient_subclient_id_shift) & subclient_id_mask)
	}
}

pub fn encode_packet(p Packet, mut w serializer.Writer) {
	write_packet_header(mut w, p.pid(), 0, 0)
	p.encode_payload(mut w)
}

pub fn encode_packet_to_bytes(p Packet) []u8 {
	mut w := serializer.new_writer()
	encode_packet(p, mut w)
	return w.bytes()
}

// Old-era (MCPE 0.6-0.15, proto 9..84) framing: a single raw byte packet id,
// no varint packing and no sub-client bytes.
pub fn encode_packet_old(p Packet, mut w serializer.Writer) {
	w.u8(u8(p.pid()))
	p.encode_payload(mut w)
}

pub fn encode_packet_old_to_bytes(p Packet) []u8 {
	mut w := serializer.new_writer()
	encode_packet_old(p, mut w)
	return w.bytes()
}

// Split header (MCPE 1.2-1.5, proto 130..274): a varuint packet id followed by
// two separate sub-client id bytes.
pub fn encode_packet_split(p Packet, mut w serializer.Writer) {
	w.write_varuint32(u32(p.pid()))
	w.u8(0)
	w.u8(0)
	p.encode_payload(mut w)
}

pub fn encode_packet_split_to_bytes(p Packet) []u8 {
	mut w := serializer.new_writer()
	encode_packet_split(p, mut w)
	return w.bytes()
}
