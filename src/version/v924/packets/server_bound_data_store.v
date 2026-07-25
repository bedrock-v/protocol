module packets

import serializer

pub struct ServerBoundDataStoreValueDouble {
pub mut:
	value f64
}

pub struct ServerBoundDataStoreValueBool {
pub mut:
	value bool
}

pub struct ServerBoundDataStoreValueString {
pub mut:
	value string
}

pub type ServerBoundDataStoreValue = ServerBoundDataStoreValueBool
	| ServerBoundDataStoreValueDouble
	| ServerBoundDataStoreValueString

pub fn (t ServerBoundDataStoreValue) encode(mut w serializer.Writer) {
	match t {
		ServerBoundDataStoreValueDouble {
			w.write_varuint32(0)
			w.le_f64(t.value)
		}
		ServerBoundDataStoreValueBool {
			w.write_varuint32(1)
			w.bool(t.value)
		}
		ServerBoundDataStoreValueString {
			w.write_varuint32(2)
			w.write_string(t.value)
		}
	}
}

pub fn ServerBoundDataStoreValue.decode(mut r serializer.Reader) !ServerBoundDataStoreValue {
	d := r.read_varuint32()!
	match d {
		0 {
			return ServerBoundDataStoreValueDouble{
				value: r.le_f64()!
			}
		}
		1 {
			return ServerBoundDataStoreValueBool{
				value: r.bool()!
			}
		}
		2 {
			return ServerBoundDataStoreValueString{
				value: r.read_string()!
			}
		}
		else {
			return error('invalid ServerBoundDataStoreValue ${d}')
		}
	}
}

pub struct ServerBoundDataStorePacket {
pub mut:
	data_store_name   string
	property          string
	path              string
	data              ServerBoundDataStoreValue = ServerBoundDataStoreValueDouble{}
	update_count      u32
	path_update_count u32
}

pub fn (p &ServerBoundDataStorePacket) pid() u16 {
	return 332
}

pub fn (p &ServerBoundDataStorePacket) name() string {
	return 'ServerBoundDataStorePacket'
}

pub fn (p &ServerBoundDataStorePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ServerBoundDataStorePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.data_store_name)
	w.write_string(p.property)
	w.write_string(p.path)
	p.data.encode(mut w)
	w.le_u32(p.update_count)
	w.le_u32(p.path_update_count)
}

pub fn (mut p ServerBoundDataStorePacket) decode_payload(mut r serializer.Reader) ! {
	p.data_store_name = r.read_string()!
	p.property = r.read_string()!
	p.path = r.read_string()!
	p.data = ServerBoundDataStoreValue.decode(mut r)!
	p.update_count = r.le_u32()!
	p.path_update_count = r.le_u32()!
}
