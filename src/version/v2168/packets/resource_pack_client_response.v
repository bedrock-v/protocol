module packets

import protocol.serializer

pub struct ResourcePackResponseCancel {}

pub struct ResourcePackResponseDownloading {
pub mut:
	downloading_packs []string
}

pub struct ResourcePackResponseDownloadingFinished {}

pub struct ResourcePackResponseStackFinished {}

pub type ResourcePackClientResponse = ResourcePackResponseCancel
	| ResourcePackResponseDownloading
	| ResourcePackResponseDownloadingFinished
	| ResourcePackResponseStackFinished

pub fn (t ResourcePackClientResponse) encode(mut w serializer.Writer) {
	match t {
		ResourcePackResponseCancel {
			w.write_varuint32(0)
			w.write_string('cancel')
		}
		ResourcePackResponseDownloading {
			w.write_varuint32(1)
			w.write_string('downloading')
			w.write_varuint32(u32(t.downloading_packs.len))
			for e in t.downloading_packs {
				w.write_string(e)
			}
		}
		ResourcePackResponseDownloadingFinished {
			w.write_varuint32(2)
			w.write_string('downloadingfinished')
		}
		ResourcePackResponseStackFinished {
			w.write_varuint32(3)
			w.write_string('resourcepackstackfinished')
		}
	}
}

pub fn ResourcePackClientResponse.decode(mut r serializer.Reader) !ResourcePackClientResponse {
	d := r.read_varuint32()!
	r.read_string()!
	match d {
		0 {
			return ResourcePackResponseCancel{}
		}
		1 {
			count := r.read_count()!
			mut packs := []string{cap: serializer.prealloc(count)}
			for _ in 0 .. count {
				packs << r.read_string()!
			}
			return ResourcePackResponseDownloading{
				downloading_packs: packs
			}
		}
		2 {
			return ResourcePackResponseDownloadingFinished{}
		}
		3 {
			return ResourcePackResponseStackFinished{}
		}
		else {
			return error('invalid ResourcePackClientResponse ${d}')
		}
	}
}

pub struct ResourcePackClientResponsePacket {
pub mut:
	response ResourcePackClientResponse = ResourcePackResponseCancel{}
}

pub fn (p &ResourcePackClientResponsePacket) pid() u16 {
	return 8
}

pub fn (p &ResourcePackClientResponsePacket) name() string {
	return 'ResourcePackClientResponsePacket'
}

pub fn (p &ResourcePackClientResponsePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ResourcePackClientResponsePacket) encode_payload(mut w serializer.Writer) {
	p.response.encode(mut w)
}

pub fn (mut p ResourcePackClientResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.response = ResourcePackClientResponse.decode(mut r)!
}
