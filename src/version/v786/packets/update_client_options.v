module packets

import serializer

pub enum GraphicsMode as i8 {
	simple     = 0
	fancy      = 1
	advanced   = 2
	ray_traced = 3
}

pub fn (e GraphicsMode) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn GraphicsMode.decode(mut r serializer.Reader) !GraphicsMode {
	return unsafe { GraphicsMode(r.i8()!) }
}

pub struct UpdateClientOptionsPacket {
pub mut:
	graphics_mode ?GraphicsMode
}

pub fn (p &UpdateClientOptionsPacket) pid() u16 { return 323 }

pub fn (p &UpdateClientOptionsPacket) name() string { return 'UpdateClientOptionsPacket' }

pub fn (p &UpdateClientOptionsPacket) can_be_sent_before_login() bool { return false }

pub fn (p &UpdateClientOptionsPacket) encode_payload(mut w serializer.Writer) {
	if v := p.graphics_mode {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn (mut p UpdateClientOptionsPacket) decode_payload(mut r serializer.Reader) ! {
	if r.bool()! {
		p.graphics_mode = GraphicsMode.decode(mut r)!
	} else {
		p.graphics_mode = none
	}
}
