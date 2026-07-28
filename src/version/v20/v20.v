module v20

import protocol
import protocol.version.v20.packets
import protocol.version.v17.packets as packets_17
import protocol.version.v15.packets as packets_15
import protocol.version.v14.packets as packets_14

pub fn new_pool() protocol.PacketPool {
	mut pool := protocol.new_empty_pool()
	pool.register(|| protocol.Packet(&packets_14.LoginPacket{}))
	pool.register(|| protocol.Packet(&packets_14.PlayStatusPacket{}))
	pool.register(|| protocol.Packet(&packets_14.MessagePacket{}))
	pool.register(|| protocol.Packet(&packets_14.SetTimePacket{}))
	pool.register(|| protocol.Packet(&packets_17.StartGamePacket{}))
	pool.register(|| protocol.Packet(&packets.AddMobPacket{}))
	pool.register(|| protocol.Packet(&packets_14.AddPlayerPacket{}))
	pool.register(|| protocol.Packet(&packets_14.RemovePlayerPacket{}))
	pool.register(|| protocol.Packet(&packets.AddEntityPacket{}))
	pool.register(|| protocol.Packet(&packets_14.RemoveEntityPacket{}))
	pool.register(|| protocol.Packet(&packets_15.AddItemEntityPacket{}))
	pool.register(|| protocol.Packet(&packets_14.TakeItemEntityPacket{}))
	pool.register(|| protocol.Packet(&packets_17.MoveEntityPacket{}))
	pool.register(|| protocol.Packet(&packets_17.RotateHeadPacket{}))
	pool.register(|| protocol.Packet(&packets.MovePlayerPacket{}))
	pool.register(|| protocol.Packet(&packets_14.RemoveBlockPacket{}))
	pool.register(|| protocol.Packet(&packets_14.UpdateBlockPacket{}))
	pool.register(|| protocol.Packet(&packets_14.AddPaintingPacket{}))
	pool.register(|| protocol.Packet(&packets_14.ExplosionPacket{}))
	pool.register(|| protocol.Packet(&packets_17.LevelEventPacket{}))
	pool.register(|| protocol.Packet(&packets_14.TileEventPacket{}))
	pool.register(|| protocol.Packet(&packets_14.EntityEventPacket{}))
	pool.register(|| protocol.Packet(&packets_14.PlayerEquipmentPacket{}))
	pool.register(|| protocol.Packet(&packets_14.PlayerArmorEquipmentPacket{}))
	pool.register(|| protocol.Packet(&packets_14.InteractPacket{}))
	pool.register(|| protocol.Packet(&packets.UseItemPacket{}))
	pool.register(|| protocol.Packet(&packets_14.PlayerActionPacket{}))
	pool.register(|| protocol.Packet(&packets_14.HurtArmorPacket{}))
	pool.register(|| protocol.Packet(&packets_14.SetEntityDataPacket{}))
	pool.register(|| protocol.Packet(&packets_17.SetEntityMotionPacket{}))
	pool.register(|| protocol.Packet(&packets_14.SetHealthPacket{}))
	pool.register(|| protocol.Packet(&packets_14.SetSpawnPositionPacket{}))
	pool.register(|| protocol.Packet(&packets_14.AnimatePacket{}))
	pool.register(|| protocol.Packet(&packets_14.RespawnPacket{}))
	pool.register(|| protocol.Packet(&packets_14.SendInventoryPacket{}))
	pool.register(|| protocol.Packet(&packets_15.DropItemPacket{}))
	pool.register(|| protocol.Packet(&packets_17.ContainerOpenPacket{}))
	pool.register(|| protocol.Packet(&packets_14.ContainerClosePacket{}))
	pool.register(|| protocol.Packet(&packets_14.ContainerSetSlotPacket{}))
	pool.register(|| protocol.Packet(&packets_14.ContainerSetDataPacket{}))
	pool.register(|| protocol.Packet(&packets_15.ContainerSetContentPacket{}))
	pool.register(|| protocol.Packet(&packets_14.ClientMessagePacket{}))
	pool.register(|| protocol.Packet(&packets_14.AdventureSettingsPacket{}))
	pool.register(|| protocol.Packet(&packets_17.EntityDataPacket{}))
	pool.register(|| protocol.Packet(&packets_17.FullChunkDataPacket{}))
	pool.register(|| protocol.Packet(&packets_17.UnloadChunkPacket{}))
	pool.register(|| protocol.Packet(&packets.SetDifficultyPacket{}))
	return pool
}
