module packets

import serializer
import version.v291.types as types_291

pub struct InteractNone {}

pub struct InteractInteract {}

pub struct InteractDamage {}

pub struct InteractLeaveVehicle {
pub mut:
	mouse_position types_291.Vector3f
}

pub struct InteractMouseover {
pub mut:
	mouse_position types_291.Vector3f
}

pub struct InteractNpcOpen {}

pub struct InteractOpenInventory {}

pub type InteractAction = InteractDamage
	| InteractInteract
	| InteractLeaveVehicle
	| InteractMouseover
	| InteractNone
	| InteractNpcOpen
	| InteractOpenInventory

pub fn (t InteractAction) id() u8 {
	return match t {
		InteractNone { u8(0) }
		InteractInteract { u8(1) }
		InteractDamage { u8(2) }
		InteractLeaveVehicle { u8(3) }
		InteractMouseover { u8(4) }
		InteractNpcOpen { u8(5) }
		InteractOpenInventory { u8(6) }
	}
}

pub fn (t InteractAction) encode_payload(mut w serializer.Writer) {
	match t {
		InteractLeaveVehicle { t.mouse_position.encode(mut w) }
		InteractMouseover { t.mouse_position.encode(mut w) }
		else {}
	}
}

pub fn InteractAction.decode_payload(id u8, mut r serializer.Reader) !InteractAction {
	match id {
		0 {
			return InteractNone{}
		}
		1 {
			return InteractInteract{}
		}
		2 {
			return InteractDamage{}
		}
		3 {
			return InteractLeaveVehicle{
				mouse_position: types_291.Vector3f.decode(mut r)!
			}
		}
		4 {
			return InteractMouseover{
				mouse_position: types_291.Vector3f.decode(mut r)!
			}
		}
		5 {
			return InteractNpcOpen{}
		}
		6 {
			return InteractOpenInventory{}
		}
		else {
			return error('invalid InteractAction ${id}')
		}
	}
}

pub struct InteractPacket {
pub mut:
	action            InteractAction = InteractNone{}
	runtime_entity_id u64
}

pub fn (p &InteractPacket) pid() u16 {
	return 33
}

pub fn (p &InteractPacket) name() string {
	return 'InteractPacket'
}

pub fn (p &InteractPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &InteractPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.action.id())
	w.write_varuint64(p.runtime_entity_id)
	p.action.encode_payload(mut w)
}

pub fn (mut p InteractPacket) decode_payload(mut r serializer.Reader) ! {
	action_id := r.u8()!
	p.runtime_entity_id = r.read_varuint64()!
	p.action = InteractAction.decode_payload(action_id, mut r)!
}
