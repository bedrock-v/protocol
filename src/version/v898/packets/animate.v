module packets

import protocol.serializer
import protocol.version.v662.types

pub enum AnimatePacketAction as i8 {
	no_action          = 0
	swing              = 1
	wake_up            = 3
	critical_hit       = 4
	magic_critical_hit = 5
}

pub enum SwingSource {
	build      = 0
	mine       = 1
	interact   = 2
	attack     = 3
	use_item   = 4
	throw_item = 5
	drop_item  = 6
	event      = 7
}

pub fn (e SwingSource) wire_name() string {
	return match e {
		.build { 'build' }
		.mine { 'mine' }
		.interact { 'interact' }
		.attack { 'attack' }
		.use_item { 'useitem' }
		.throw_item { 'throwitem' }
		.drop_item { 'dropitem' }
		.event { 'event' }
	}
}

pub fn (e SwingSource) encode(mut w serializer.Writer) {
	w.write_string(e.wire_name())
}

pub fn SwingSource.decode(mut r serializer.Reader) !SwingSource {
	s := r.read_string()!
	match s {
		'build' { return SwingSource.build }
		'mine' { return SwingSource.mine }
		'interact' { return SwingSource.interact }
		'attack' { return SwingSource.attack }
		'useitem' { return SwingSource.use_item }
		'throwitem' { return SwingSource.throw_item }
		'dropitem' { return SwingSource.drop_item }
		'event' { return SwingSource.event }
		else { return error('invalid SwingSource ${s}') }
	}
}

pub struct AnimatePacket {
pub mut:
	action            AnimatePacketAction
	target_runtime_id types.ActorRuntimeID
	data              f32
	swing_source      ?SwingSource
}

pub fn (p &AnimatePacket) pid() u16 {
	return 44
}

pub fn (p &AnimatePacket) name() string {
	return 'AnimatePacket'
}

pub fn (p &AnimatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AnimatePacket) encode_payload(mut w serializer.Writer) {
	w.i8(i8(p.action))
	p.target_runtime_id.encode(mut w)
	w.le_f32(p.data)
	if v := p.swing_source {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn (mut p AnimatePacket) decode_payload(mut r serializer.Reader) ! {
	p.action = unsafe { AnimatePacketAction(r.i8()!) }
	p.target_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.data = r.le_f32()!
	if r.bool()! {
		p.swing_source = SwingSource.decode(mut r)!
	}
}
