module enums

import protocol.serializer

pub struct CommandOriginPlayer {}

pub struct CommandOriginCommandBlock {}

pub struct CommandOriginMinecartCommandBlock {}

pub struct CommandOriginDevConsole {
pub mut:
	value i64
}

pub struct CommandOriginTest {
pub mut:
	value i64
}

pub struct CommandOriginAutomationPlayer {}

pub struct CommandOriginClientAutomation {}

pub struct CommandOriginDedicatedServer {}

pub struct CommandOriginEntity {}

pub struct CommandOriginVirtual {}

pub struct CommandOriginGameArgument {}

pub struct CommandOriginEntityServer {}

pub struct CommandOriginPrecompiled {}

pub struct CommandOriginGameDirectorEntityServer {}

pub struct CommandOriginScripting {}

pub struct CommandOriginExecuteContext {}

pub type CommandOriginType = CommandOriginAutomationPlayer
	| CommandOriginClientAutomation
	| CommandOriginCommandBlock
	| CommandOriginDedicatedServer
	| CommandOriginDevConsole
	| CommandOriginEntity
	| CommandOriginEntityServer
	| CommandOriginExecuteContext
	| CommandOriginGameArgument
	| CommandOriginGameDirectorEntityServer
	| CommandOriginMinecartCommandBlock
	| CommandOriginPlayer
	| CommandOriginPrecompiled
	| CommandOriginScripting
	| CommandOriginTest
	| CommandOriginVirtual

pub fn (t CommandOriginType) id() u32 {
	return match t {
		CommandOriginPlayer { u32(0) }
		CommandOriginCommandBlock { u32(1) }
		CommandOriginMinecartCommandBlock { u32(2) }
		CommandOriginDevConsole { u32(3) }
		CommandOriginTest { u32(4) }
		CommandOriginAutomationPlayer { u32(5) }
		CommandOriginClientAutomation { u32(6) }
		CommandOriginDedicatedServer { u32(7) }
		CommandOriginEntity { u32(8) }
		CommandOriginVirtual { u32(9) }
		CommandOriginGameArgument { u32(10) }
		CommandOriginEntityServer { u32(11) }
		CommandOriginPrecompiled { u32(12) }
		CommandOriginGameDirectorEntityServer { u32(13) }
		CommandOriginScripting { u32(14) }
		CommandOriginExecuteContext { u32(15) }
	}
}

pub fn (t CommandOriginType) encode_payload(mut w serializer.Writer) {
	match t {
		CommandOriginDevConsole { w.write_varint64(t.value) }
		CommandOriginTest { w.write_varint64(t.value) }
		else {}
	}
}

pub fn CommandOriginType.decode_payload(id u32, mut r serializer.Reader) !CommandOriginType {
	match id {
		0 {
			return CommandOriginPlayer{}
		}
		1 {
			return CommandOriginCommandBlock{}
		}
		2 {
			return CommandOriginMinecartCommandBlock{}
		}
		3 {
			return CommandOriginDevConsole{
				value: r.read_varint64()!
			}
		}
		4 {
			return CommandOriginTest{
				value: r.read_varint64()!
			}
		}
		5 {
			return CommandOriginAutomationPlayer{}
		}
		6 {
			return CommandOriginClientAutomation{}
		}
		7 {
			return CommandOriginDedicatedServer{}
		}
		8 {
			return CommandOriginEntity{}
		}
		9 {
			return CommandOriginVirtual{}
		}
		10 {
			return CommandOriginGameArgument{}
		}
		11 {
			return CommandOriginEntityServer{}
		}
		12 {
			return CommandOriginPrecompiled{}
		}
		13 {
			return CommandOriginGameDirectorEntityServer{}
		}
		14 {
			return CommandOriginScripting{}
		}
		15 {
			return CommandOriginExecuteContext{}
		}
		else {
			return error('invalid CommandOriginType ${id}')
		}
	}
}

pub fn (t CommandOriginType) encode(mut w serializer.Writer) {
	w.write_varuint32(t.id())
	t.encode_payload(mut w)
}

pub fn CommandOriginType.decode(mut r serializer.Reader) !CommandOriginType {
	d := r.read_varuint32()!
	return CommandOriginType.decode_payload(d, mut r)!
}
