module packets

import protocol.serializer

pub struct UpdateBlockRecord {
pub mut:
	x        i32
	z        i32
	y        u8
	block_id u8
	meta     u8
	flags    u8
}

pub struct UpdateBlockPacket {
pub mut:
	records []UpdateBlockRecord
}

pub fn (p &UpdateBlockPacket) pid() u16 {
	return 0x91
}

pub fn (p &UpdateBlockPacket) name() string {
	return 'UpdateBlockPacket'
}

pub fn (p &UpdateBlockPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateBlockPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(i32(p.records.len))
	for rec in p.records {
		w.be_i32(rec.x)
		w.be_i32(rec.z)
		w.u8(rec.y)
		w.u8(rec.block_id)
		w.u8((rec.flags << 4) | (rec.meta & 0x0f))
	}
}

pub fn (mut p UpdateBlockPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.be_i32()!)
	p.records = []UpdateBlockRecord{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		x := r.be_i32()!
		z := r.be_i32()!
		y := r.u8()!
		block_id := r.u8()!
		b := r.u8()!
		p.records << UpdateBlockRecord{
			x:        x
			z:        z
			y:        y
			block_id: block_id
			meta:     b & 0x0f
			flags:    b >> 4
		}
	}
}
