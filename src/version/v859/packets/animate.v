module packets

import protocol.serializer
import protocol.version.v662.types

pub struct AnimateNoAction {}

pub struct AnimateSwing {}

pub struct AnimateWakeUp {}

pub struct AnimateCriticalHit {}

pub struct AnimateMagicCriticalHit {}

pub struct AnimateRowRight {
pub mut:
	rowing_time f32
}

pub struct AnimateRowLeft {
pub mut:
	rowing_time f32
}

pub type AnimateAction = AnimateCriticalHit
	| AnimateMagicCriticalHit
	| AnimateNoAction
	| AnimateRowLeft
	| AnimateRowRight
	| AnimateSwing
	| AnimateWakeUp

pub fn (t AnimateAction) id() i32 {
	return match t {
		AnimateNoAction { i32(0) }
		AnimateSwing { i32(1) }
		AnimateWakeUp { i32(3) }
		AnimateCriticalHit { i32(4) }
		AnimateMagicCriticalHit { i32(5) }
		AnimateRowRight { i32(128) }
		AnimateRowLeft { i32(129) }
	}
}

pub fn (t AnimateAction) encode_payload(mut w serializer.Writer) {
	match t {
		AnimateRowRight { w.le_f32(t.rowing_time) }
		AnimateRowLeft { w.le_f32(t.rowing_time) }
		else {}
	}
}

pub fn AnimateAction.decode_payload(id i32, mut r serializer.Reader) !AnimateAction {
	match id {
		0 { return AnimateNoAction{} }
		1 { return AnimateSwing{} }
		3 { return AnimateWakeUp{} }
		4 { return AnimateCriticalHit{} }
		5 { return AnimateMagicCriticalHit{} }
		128 { return AnimateRowRight{
				rowing_time: r.le_f32()!
			} }
		129 { return AnimateRowLeft{
				rowing_time: r.le_f32()!
			} }
		else { return error('invalid AnimateAction ${id}') }
	}
}

pub struct AnimatePacket {
pub mut:
	action            AnimateAction = AnimateNoAction{}
	target_runtime_id types.ActorRuntimeID
	data              f32
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
	w.write_varint32(p.action.id())
	p.target_runtime_id.encode(mut w)
	w.le_f32(p.data)
	p.action.encode_payload(mut w)
}

pub fn (mut p AnimatePacket) decode_payload(mut r serializer.Reader) ! {
	action_id := r.read_varint32()!
	p.target_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.data = r.le_f32()!
	p.action = AnimateAction.decode_payload(action_id, mut r)!
}
