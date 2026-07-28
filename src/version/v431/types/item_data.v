module types

import protocol.serializer

pub struct ItemData {
pub mut:
	runtime_id       i32
	count            u16
	damage           u32
	using_net_id     bool
	net_id           i32
	block_runtime_id i32
	user_data        []u8
}

fn (t ItemData) encode_user_data(mut w serializer.Writer) {
	w.write_item_extra_data(t.user_data)
}

fn (mut t ItemData) decode_user_data(mut r serializer.Reader) ! {
	t.user_data = r.read_item_extra_data()!
}

pub fn (t ItemData) encode(mut w serializer.Writer) {
	if t.runtime_id == 0 {
		w.write_varint32(0)
		return
	}
	w.write_varint32(t.runtime_id)
	w.le_u16(t.count)
	w.write_varuint32(t.damage)
	w.bool(t.using_net_id)
	if t.using_net_id {
		w.write_varint32(t.net_id)
	}
	w.write_varint32(t.block_runtime_id)
	t.encode_user_data(mut w)
}

pub fn ItemData.decode(mut r serializer.Reader) !ItemData {
	mut t := ItemData{}
	t.runtime_id = r.read_varint32()!
	if t.runtime_id == 0 {
		return t
	}
	t.count = r.le_u16()!
	t.damage = r.read_varuint32()!
	t.using_net_id = r.bool()!
	if t.using_net_id {
		t.net_id = r.read_varint32()!
	}
	t.block_runtime_id = r.read_varint32()!
	t.decode_user_data(mut r)!
	return t
}

pub fn (t ItemData) encode_instance(mut w serializer.Writer) {
	if t.runtime_id == 0 {
		w.write_varint32(0)
		return
	}
	w.write_varint32(t.runtime_id)
	w.le_u16(t.count)
	w.write_varuint32(t.damage)
	w.write_varint32(t.block_runtime_id)
	t.encode_user_data(mut w)
}

pub fn ItemData.decode_instance(mut r serializer.Reader) !ItemData {
	mut t := ItemData{}
	t.runtime_id = r.read_varint32()!
	if t.runtime_id == 0 {
		return t
	}
	t.count = r.le_u16()!
	t.damage = r.read_varuint32()!
	t.block_runtime_id = r.read_varint32()!
	t.decode_user_data(mut r)!
	return t
}
