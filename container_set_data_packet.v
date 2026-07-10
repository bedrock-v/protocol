module protocol


pub struct ContainerSetDataPacket {
pub mut:
	window_id int
	property  int
	value     int
}

pub fn (p &ContainerSetDataPacket) pid() u16 {
	return container_set_data_packet
}

pub fn (p &ContainerSetDataPacket) name() string {
	return 'ContainerSetDataPacket'
}

pub fn (p &ContainerSetDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ContainerSetDataPacket) decode_payload(mut r Reader) ! {
	p.window_id = int(r.u8()!)
	p.property = int(r.read_varint32()!)
	p.value = int(r.read_varint32()!)
}

pub fn (p &ContainerSetDataPacket) encode_payload(mut w Writer) {
	w.u8(u8(p.window_id))
	w.write_varint32(i32(p.property))
	w.write_varint32(i32(p.value))
}
