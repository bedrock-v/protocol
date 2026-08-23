module packets

import protocol.serializer

pub struct TimeMarker {
pub mut:
	id     u64
	name   string
	time   i32
	period ?i32
}

pub fn (t TimeMarker) encode(mut w serializer.Writer) {
	w.write_varuint64(t.id)
	w.write_string(t.name)
	w.write_varint32(t.time)
	if v := t.period {
		w.bool(true)
		w.le_i32(v)
	} else {
		w.bool(false)
	}
}

pub fn TimeMarker.decode(mut r serializer.Reader) !TimeMarker {
	mut t := TimeMarker{
		id:   r.read_varuint64()!
		name: r.read_string()!
		time: r.read_varint32()!
	}
	if r.bool()! {
		t.period = r.le_i32()!
	}
	return t
}

pub struct SyncWorldClockState {
pub mut:
	clock_id u64
	time     i32
	paused   bool
}

pub fn (t SyncWorldClockState) encode(mut w serializer.Writer) {
	w.write_varuint64(t.clock_id)
	w.write_varint32(t.time)
	w.bool(t.paused)
}

pub fn SyncWorldClockState.decode(mut r serializer.Reader) !SyncWorldClockState {
	return SyncWorldClockState{
		clock_id: r.read_varuint64()!
		time:     r.read_varint32()!
		paused:   r.bool()!
	}
}

pub struct WorldClock {
pub mut:
	id           u64
	name         string
	time         i32
	paused       bool
	time_markers []TimeMarker
}

pub fn (t WorldClock) encode(mut w serializer.Writer) {
	w.write_varuint64(t.id)
	w.write_string(t.name)
	w.write_varint32(t.time)
	w.bool(t.paused)
	w.write_varuint32(u32(t.time_markers.len))
	for e in t.time_markers {
		e.encode(mut w)
	}
}

pub fn WorldClock.decode(mut r serializer.Reader) !WorldClock {
	mut t := WorldClock{}
	t.id = r.read_varuint64()!
	t.name = r.read_string()!
	t.time = r.read_varint32()!
	t.paused = r.bool()!
	count := r.read_count()!
	t.time_markers = []TimeMarker{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		t.time_markers << TimeMarker.decode(mut r)!
	}
	return t
}

pub struct WorldClocksSyncState {
pub mut:
	clock_data []SyncWorldClockState
}

pub struct WorldClocksInitializeRegistry {
pub mut:
	clock_data []WorldClock
}

pub struct WorldClocksAddTimeMarker {
pub mut:
	clock_id     u64
	time_markers []TimeMarker
}

pub struct WorldClocksRemoveTimeMarker {
pub mut:
	clock_id        u64
	time_marker_ids []u64
}

pub type SyncWorldClocks = WorldClocksAddTimeMarker
	| WorldClocksInitializeRegistry
	| WorldClocksRemoveTimeMarker
	| WorldClocksSyncState

pub fn (t SyncWorldClocks) encode(mut w serializer.Writer) {
	match t {
		WorldClocksSyncState {
			w.write_varuint32(0)
			w.write_varuint32(u32(t.clock_data.len))
			for e in t.clock_data {
				e.encode(mut w)
			}
		}
		WorldClocksInitializeRegistry {
			w.write_varuint32(1)
			w.write_varuint32(u32(t.clock_data.len))
			for e in t.clock_data {
				e.encode(mut w)
			}
		}
		WorldClocksAddTimeMarker {
			w.write_varuint32(2)
			w.write_varuint64(t.clock_id)
			w.write_varuint32(u32(t.time_markers.len))
			for e in t.time_markers {
				e.encode(mut w)
			}
		}
		WorldClocksRemoveTimeMarker {
			w.write_varuint32(3)
			w.write_varuint64(t.clock_id)
			w.write_varuint32(u32(t.time_marker_ids.len))
			for id in t.time_marker_ids {
				w.write_varuint64(id)
			}
		}
	}
}

pub fn SyncWorldClocks.decode(mut r serializer.Reader) !SyncWorldClocks {
	d := r.read_varuint32()!
	match d {
		0 {
			count := r.read_count()!
			mut clock_data := []SyncWorldClockState{cap: serializer.prealloc(count)}
			for _ in 0 .. count {
				clock_data << SyncWorldClockState.decode(mut r)!
			}
			return WorldClocksSyncState{
				clock_data: clock_data
			}
		}
		1 {
			count := r.read_count()!
			mut clock_data := []WorldClock{cap: serializer.prealloc(count)}
			for _ in 0 .. count {
				clock_data << WorldClock.decode(mut r)!
			}
			return WorldClocksInitializeRegistry{
				clock_data: clock_data
			}
		}
		2 {
			clock_id := r.read_varuint64()!
			count := r.read_count()!
			mut time_markers := []TimeMarker{cap: serializer.prealloc(count)}
			for _ in 0 .. count {
				time_markers << TimeMarker.decode(mut r)!
			}
			return WorldClocksAddTimeMarker{
				clock_id:     clock_id
				time_markers: time_markers
			}
		}
		3 {
			clock_id := r.read_varuint64()!
			count := r.read_count()!
			mut ids := []u64{cap: serializer.prealloc(count)}
			for _ in 0 .. count {
				ids << r.read_varuint64()!
			}
			return WorldClocksRemoveTimeMarker{
				clock_id:        clock_id
				time_marker_ids: ids
			}
		}
		else {
			return error('invalid SyncWorldClocks ${d}')
		}
	}
}

pub struct SyncWorldClocksPacket {
pub mut:
	data SyncWorldClocks = WorldClocksSyncState{}
}

pub fn (p &SyncWorldClocksPacket) pid() u16 {
	return 344
}

pub fn (p &SyncWorldClocksPacket) name() string {
	return 'SyncWorldClocksPacket'
}

pub fn (p &SyncWorldClocksPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SyncWorldClocksPacket) encode_payload(mut w serializer.Writer) {
	p.data.encode(mut w)
}

pub fn (mut p SyncWorldClocksPacket) decode_payload(mut r serializer.Reader) ! {
	p.data = SyncWorldClocks.decode(mut r)!
}
