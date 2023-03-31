using ModWobblyLife.Audio;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife.Network;

public class ModHideAndSeekCraneCrawler : ModNetworkSubBehaviour
{
    private byte RPC_CLIENT_SET_DOOR_MOVING;

    [SerializeField] private string movingSound = "event:/HideAndSeekDemo/HideAndSeekDemo_Crane_Move";
    [SerializeField] private bool bMovingSoundTriggerCue;
    [SerializeField] private Transform soundTransform;

    private ModEventInstance movingInstance;

    protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
    {
        base.ModRegisterRPCs(modNetworkObject);

        RPC_CLIENT_SET_DOOR_MOVING = modNetworkObject.RegisterRPC(ClientSetDoorMoving);
    }

    void OnDestroy()
    {
        if (movingInstance.IsValid())
        {
            movingInstance.Stop(MOD_STOP_MODE.IMMEDIATE);
            movingInstance.Release();
        }
    }

    public void AnimationEvent_StartMoving()
    {
        ServerSetDoorMoving(true);
    }

    public void AnimationEvent_StopMoving()
    {
        ServerSetDoorMoving(false);
    }

    public void ServerSetDoorMoving(bool bMoving)
    {
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        modNetworkObject.SendRPC(RPC_CLIENT_SET_DOOR_MOVING, true, ModRPCRecievers.OthersBuffered, ModNetworkManager.Instance.GetTimestep(), bMoving);

        SetDoorMoving(bMoving);
    }

    void SetDoorMoving(bool bMoving)
    {
        if (bMoving)
        {
            if (!movingInstance.IsValid() && !string.IsNullOrEmpty(movingSound))
            {
                movingInstance = ModRuntimeManager.CreateInstance(movingSound);
                ModRuntimeManager.AttachInstanceToGameObject(movingInstance, soundTransform.transform, (Rigidbody)null);
                movingInstance.Start();
            }
        }
        else
        {
            if (movingInstance.IsValid())
            {
                if (bMovingSoundTriggerCue)
                {
                    movingInstance.TriggerCue();
                }
                else
                {
                    movingInstance.Stop(MOD_STOP_MODE.ALLOWFADEOUT);
                }

                movingInstance.Release();
                movingInstance.ClearHandle();
            }
        }
    }

    #region RPC Callbacks

    private ulong doorMovingTimestep;

    void ClientSetDoorMoving(ModNetworkReader reader, ModRPCInfo info)
    {
        if (!info.sender.IsHost) return;

        ulong timestep = reader.ReadUInt64();

        if (doorMovingTimestep >= timestep)
            return;

        doorMovingTimestep = timestep;

        SetDoorMoving(reader.ReadBoolean());
    }

    #endregion
}
