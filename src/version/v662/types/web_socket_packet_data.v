module types

import serializer

pub struct WebSocketPacketData {
pub mut:
	web_socket_server_uri string
}

pub fn (t WebSocketPacketData) encode(mut w serializer.Writer) {
	w.write_string(t.web_socket_server_uri)
}

pub fn WebSocketPacketData.decode(mut r serializer.Reader) !WebSocketPacketData {
	return WebSocketPacketData{
		web_socket_server_uri: r.read_string()!
	}
}
