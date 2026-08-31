module v9

import protocol
import protocol.version.v9.packets

pub fn new_pool() protocol.PacketPool {
	mut pool := protocol.new_empty_pool()
	pool.register(|| protocol.Packet(&packets.KeepAlivePacket{}))
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
	pool.register(|| protocol.Packet(&packets.AddMobPacket{}))
	pool.register(|| protocol.Packet(&packets.AddPlayerPacket{}))
	pool.register(|| protocol.Packet(&packets.AddEntityPacket{}))
	pool.register(|| protocol.Packet(&packets.RemoveEntityPacket{}))
	pool.register(|| protocol.Packet(&packets.AddItemEntityPacket{}))
	pool.register(|| protocol.Packet(&packets.MoveEntityPacket{}))
	pool.register(|| protocol.Packet(&packets.MoveEntityPosRotPacket{}))
	pool.register(|| protocol.Packet(&packets.MovePlayerPacket{}))
	pool.register(|| protocol.Packet(&packets.PlaceBlockPacket{}))
	pool.register(|| protocol.Packet(&packets.RemoveBlockPacket{}))
	pool.register(|| protocol.Packet(&packets.UpdateBlockPacket{}))
	pool.register(|| protocol.Packet(&packets.RequestChunkPacket{}))
	pool.register(|| protocol.Packet(&packets.ChunkDataPacket{}))
	pool.register(|| protocol.Packet(&packets.PlayerEquipmentPacket{}))
	pool.register(|| protocol.Packet(&packets.InteractPacket{}))
	pool.register(|| protocol.Packet(&packets.UseItemPacket{}))
	pool.register(|| protocol.Packet(&packets.SetEntityDataPacket{}))
	pool.register(|| protocol.Packet(&packets.SetHealthPacket{}))
	pool.register(|| protocol.Packet(&packets.AnimatePacket{}))
	pool.register(|| protocol.Packet(&packets.RespawnPacket{}))
	pool.register(|| protocol.Packet(&packets.ClientMessagePacket{}))
	pool.register(|| protocol.Packet(&packets.SignUpdatePacket{}))
	pool.register(|| protocol.Packet(&packets.AdventureSettingsPacket{}))
	return pool
}
