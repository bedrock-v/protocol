module v5

import protocol
import version.v14.packets

pub fn new_pool() protocol.PacketPool {
	mut pool := protocol.new_empty_pool()
	pool.register(|| protocol.Packet(&packets.PingPacket{}))
	pool.register(|| protocol.Packet(&packets.ClientConnectPacket{}))
	pool.register(|| protocol.Packet(&packets.ServerHandshakePacket{}))
	pool.register(|| protocol.Packet(&packets.ClientHandshakePacket{}))
	pool.register(|| protocol.Packet(&packets.DisconnectPacket{}))
	pool.register(|| protocol.Packet(&packets.LoginPacket{}))
	pool.register(|| protocol.Packet(&packets.PlayStatusPacket{}))
	pool.register(|| protocol.Packet(&packets.ReadyPacket{}))
	pool.register(|| protocol.Packet(&packets.MessagePacket{}))
	pool.register(|| protocol.Packet(&packets.SetTimePacket{}))
	pool.register(|| protocol.Packet(&packets.StartGamePacket{}))
	pool.register(|| protocol.Packet(&packets.AddPlayerPacket{}))
	pool.register(|| protocol.Packet(&packets.AddEntityPacket{}))
	pool.register(|| protocol.Packet(&packets.MoveEntityPacket{}))
	pool.register(|| protocol.Packet(&packets.MovePlayerPacket{}))
	pool.register(|| protocol.Packet(&packets.PlaceBlockPacket{}))
	pool.register(|| protocol.Packet(&packets.RemoveBlockPacket{}))
	pool.register(|| protocol.Packet(&packets.UpdateBlockPacket{}))
	pool.register(|| protocol.Packet(&packets.SetHealthPacket{}))
	pool.register(|| protocol.Packet(&packets.RespawnPacket{}))
	return pool
}
