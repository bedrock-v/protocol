module types

import serializer

pub const raknet_magic = [u8(0x00), 0xff, 0xff, 0x00, 0xfe, 0xfe, 0xfe, 0xfe, 0xfd, 0xfd, 0xfd,
	0xfd, 0x12, 0x34, 0x56, 0x78]

pub fn read_triad(mut r serializer.Reader) !u32 {
	b := r.read_raw(3)!
	return (u32(b[0]) << 16) | (u32(b[1]) << 8) | u32(b[2])
}

pub fn write_triad(mut w serializer.Writer, value u32) {
	w.u8(u8((value >> 16) & 0xff))
	w.u8(u8((value >> 8) & 0xff))
	w.u8(u8(value & 0xff))
}

pub fn read_data_array(mut r serializer.Reader, len int) ![][]u8 {
	mut data := [][]u8{}
	for _ in 0 .. len {
		if r.remaining() == 0 {
			break
		}
		l := int(read_triad(mut r)!)
		data << r.read_raw(l)!
	}
	return data
}

pub fn write_data_array(mut w serializer.Writer, data [][]u8) {
	for v in data {
		write_triad(mut w, u32(v.len))
		w.write_raw(v)
	}
}
