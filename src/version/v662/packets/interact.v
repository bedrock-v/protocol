module packets

import serializer
import version.v662.types

pub struct InteractInvalid {}

pub struct InteractInteract {}

pub struct InteractDamage {}

pub struct InteractStopRiding {
pub mut:
	position_x f32
	position_y f32
	position_z f32
}

pub struct InteractInteractUpdate {
pub mut:
	position_x f32
	position_y f32
	position_z f32
}

pub struct InteractNpcOpen {}

pub struct InteractOpenInventory {}

pub type InteractAction = InteractDamage
	| InteractInteract
	| InteractInteractUpdate
	| InteractInvalid
	| InteractNpcOpen
	| InteractOpenInventory
	| InteractStopRiding

pub fn (t InteractAction) id() i8 {
	return match t {
		InteractInvalid { i8(0) }
		InteractInteract { i8(1) }
		InteractDamage { i8(2) }
		InteractStopRiding { i8(3) }
		InteractInteractUpdate { i8(4) }
		InteractNpcOpen { i8(5) }
		InteractOpenInventory { i8(6) }
	}
}

pub fn (t InteractAction) encode_payload(mut w serializer.Writer) {
	match t {
		InteractStopRiding {
			w.le_f32(t.position_x)
			w.le_f32(t.position_y)
			w.le_f32(t.position_z)
		}
		InteractInteractUpdate {
			w.le_f32(t.position_x)
			w.le_f32(t.position_y)
			w.le_f32(t.position_z)
		}
		else {}
	}
}

pub fn InteractAction.decode_payload(id i8, mut r serializer.Reader) !InteractAction {
	match id {
		0 { return InteractInvalid{} }
		1 { return InteractInteract{} }
		2 { return InteractDamage{} }
		3 {
			return InteractStopRiding{
				position_x: r.le_f32()!
				position_y: r.le_f32()!
				position_z: r.le_f32()!
			}
		}
		4 {
			return InteractInteractUpdate{
				position_x: r.le_f32()!
				position_y: r.le_f32()!
				position_z: r.le_f32()!
			}
		}
		5 { return InteractNpcOpen{} }
		6 { return InteractOpenInventory{} }
		else { return error('invalid InteractAction ${id}') }
	}
}

pub struct InteractPacket {
pub mut:
	action            InteractAction = InteractInvalid{}
	target_runtime_id types.ActorRuntimeID
}

pub fn (p &InteractPacket) pid() u16 { return 33 }

pub fn (p &InteractPacket) name() string { return 'InteractPacket' }

pub fn (p &InteractPacket) can_be_sent_before_login() bool { return false }

pub fn (p &InteractPacket) encode_payload(mut w serializer.Writer) {
	w.i8(p.action.id())
	p.target_runtime_id.encode(mut w)
	p.action.encode_payload(mut w)
}

pub fn (mut p InteractPacket) decode_payload(mut r serializer.Reader) ! {
	action_id := r.i8()!
	p.target_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.action = InteractAction.decode_payload(action_id, mut r)!
}
