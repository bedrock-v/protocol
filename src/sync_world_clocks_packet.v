module protocol

import serializer

pub const clock_payload_type_sync_state = u32(0)
pub const clock_payload_type_initialize_registry = u32(1)
pub const clock_payload_type_add_time_marker = u32(2)
pub const clock_payload_type_remove_time_marker = u32(3)

pub struct SyncWorldClockStateData {
pub mut:
	clock_id u64
	time     int
	paused   bool
}

pub struct TimeMarkerData {
pub mut:
	id          u64
	name        string
	time        int
	has_period  bool
	period      int
}

pub struct WorldClockData {
pub mut:
	id           u64
	name         string
	time         int
	paused       bool
	time_markers []TimeMarkerData
}

pub struct SyncWorldClocksPacket {
pub mut:
	payload_type            u32
	sync_states             []SyncWorldClockStateData
	clocks                  []WorldClockData
	add_clock_id            u64
	add_time_markers        []TimeMarkerData
	remove_clock_id         u64
	remove_time_marker_ids  []u64
}

pub fn (p &SyncWorldClocksPacket) pid() u16 {
	return sync_world_clocks_packet
}

pub fn (p &SyncWorldClocksPacket) name() string {
	return 'SyncWorldClocksPacket'
}

pub fn (p &SyncWorldClocksPacket) can_be_sent_before_login() bool {
	return false
}

fn read_time_marker(mut r serializer.Reader) !TimeMarkerData {
	mut m := TimeMarkerData{
		id:   r.read_varuint64()!
		name: r.read_string()!
		time: r.read_varint32()!
	}
	if r.bool()! {
		m.has_period = true
		m.period = r.le_i32()!
	}
	return m
}

fn write_time_marker(mut w serializer.Writer, m TimeMarkerData) {
	w.write_varuint64(m.id)
	w.write_string(m.name)
	w.write_varint32(m.time)
	if m.has_period {
		w.bool(true)
		w.le_i32(m.period)
	} else {
		w.bool(false)
	}
}

pub fn (mut p SyncWorldClocksPacket) decode_payload(mut r serializer.Reader) ! {
	p.payload_type = r.read_varuint32()!
	match p.payload_type {
		clock_payload_type_sync_state {
			count := r.read_varuint32()!
			p.sync_states = []SyncWorldClockStateData{}
			for _ in 0 .. count {
				p.sync_states << SyncWorldClockStateData{
					clock_id: r.read_varuint64()!
					time:     r.read_varint32()!
					paused:   r.bool()!
				}
			}
		}
		clock_payload_type_initialize_registry {
			count := r.read_varuint32()!
			p.clocks = []WorldClockData{}
			for _ in 0 .. count {
				mut c := WorldClockData{
					id:     r.read_varuint64()!
					name:   r.read_string()!
					time:   r.read_varint32()!
					paused: r.bool()!
				}
				marker_count := r.read_varuint32()!
				c.time_markers = []TimeMarkerData{}
				for _ in 0 .. marker_count {
					c.time_markers << read_time_marker(mut r)!
				}
				p.clocks << c
			}
		}
		clock_payload_type_add_time_marker {
			p.add_clock_id = r.read_varuint64()!
			count := r.read_varuint32()!
			p.add_time_markers = []TimeMarkerData{}
			for _ in 0 .. count {
				p.add_time_markers << read_time_marker(mut r)!
			}
		}
		clock_payload_type_remove_time_marker {
			p.remove_clock_id = r.read_varuint64()!
			count := r.read_varuint32()!
			p.remove_time_marker_ids = []u64{}
			for _ in 0 .. count {
				p.remove_time_marker_ids << r.read_varuint64()!
			}
		}
		else {}
	}
}

pub fn (p &SyncWorldClocksPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.payload_type)
	match p.payload_type {
		clock_payload_type_sync_state {
			w.write_varuint32(u32(p.sync_states.len))
			for s in p.sync_states {
				w.write_varuint64(s.clock_id)
				w.write_varint32(s.time)
				w.bool(s.paused)
			}
		}
		clock_payload_type_initialize_registry {
			w.write_varuint32(u32(p.clocks.len))
			for c in p.clocks {
				w.write_varuint64(c.id)
				w.write_string(c.name)
				w.write_varint32(c.time)
				w.bool(c.paused)
				w.write_varuint32(u32(c.time_markers.len))
				for m in c.time_markers {
					write_time_marker(mut w, m)
				}
			}
		}
		clock_payload_type_add_time_marker {
			w.write_varuint64(p.add_clock_id)
			w.write_varuint32(u32(p.add_time_markers.len))
			for m in p.add_time_markers {
				write_time_marker(mut w, m)
			}
		}
		clock_payload_type_remove_time_marker {
			w.write_varuint64(p.remove_clock_id)
			w.write_varuint32(u32(p.remove_time_marker_ids.len))
			for id in p.remove_time_marker_ids {
				w.write_varuint64(id)
			}
		}
		else {}
	}
}
