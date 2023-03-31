using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife.Network;
using System;

[DisallowMultipleComponent]
public class ModConveyorBeltPlatformNetwork : ModNetworkBehaviour
{
	private byte RPC_CLIENT_SYNC_BELT_CHANGED;
	private byte RPC_CLIENT_SPEED_CHANGED;

	private ModConveyorBeltPlatform conveyorBeltPlatform;
	private bool syncBeltDirty;

    protected override void ModAwake()
    {
        base.ModAwake();

		conveyorBeltPlatform = GetComponent<ModConveyorBeltPlatform>();

		conveyorBeltPlatform.onConveyorBeltOnChanged += OnConveyorBeltStateChanged;
		conveyorBeltPlatform.onConveyorBeltSpeedChanged += OnConveyorBeltSpeedChanged;
	}

    protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
	{
		base.ModRegisterRPCs(modNetworkObject);

		RPC_CLIENT_SYNC_BELT_CHANGED = modNetworkObject.RegisterRPC(ClientSyncBeltChanged);
		RPC_CLIENT_SPEED_CHANGED = modNetworkObject.RegisterRPC(ClientSpeedChanged);
	}

    protected override void ModNetworkPost(ModNetworkObject modNetworkObject)
    {
        base.ModNetworkPost(modNetworkObject);

		if(modNetworkObject.IsServer() && syncBeltDirty)
        {
			ServerSyncBeltState(conveyorBeltPlatform.IsOn());
			ServerSpeed(conveyorBeltPlatform.GetSpeed());
		}
    }

    void OnConveyorBeltStateChanged(bool bIsOn)
	{
		ServerSyncBeltState(bIsOn);
	}

	void OnConveyorBeltSpeedChanged(float speed)
	{
		ServerSpeed(speed);
	}

	#region RPC

	void ServerSyncBeltState(bool bIsOn)
	{
		if(modNetworkObject == null)
        {
			syncBeltDirty = true;
			return;
		}

		if (!modNetworkObject.IsServer()) return;

		modNetworkObject.SendRPC(RPC_CLIENT_SYNC_BELT_CHANGED, true, ModRPCRecievers.OthersBuffered, bIsOn);
	}

	void ServerSpeed(float speed)
	{
		if (modNetworkObject == null)
		{
			syncBeltDirty = true;
			return;
		}

		if (!modNetworkObject.IsServer()) return;

		modNetworkObject.SendRPC(RPC_CLIENT_SPEED_CHANGED, true, ModRPCRecievers.OthersBuffered, speed);
	}

	#endregion

	#region RPC Callbacks

	void ClientSpeedChanged(ModNetworkReader reader, ModRPCInfo info)
	{
		if (!info.sender.IsHost) return;
		if (modNetworkObject.IsServer()) return;

		if (conveyorBeltPlatform)
		{
			float speed = reader.ReadSingle();
			conveyorBeltPlatform.SetSpeed(speed);
		}
	}

	void ClientSyncBeltChanged(ModNetworkReader reader, ModRPCInfo info)
	{
		if (!info.sender.IsHost) return;

		if (conveyorBeltPlatform)
		{
			bool bIsOn = reader.ReadBoolean();
			conveyorBeltPlatform.SetIsOn_Internal(bIsOn);
		}
	}

	#endregion
}
