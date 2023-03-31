using ModWobblyLife;
using ModWobblyLife.Audio;
using ModWobblyLife.Network;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModHideAndSeekSlidingDoor : ModNetworkBehaviour, ModIHideAndSeekSeekerDoor
{
    private byte RPC_CLIENT_SET_DOOR_OPEN;
    private byte RPC_CLIENT_SET_DOOR_MOVING;

    [SerializeField] private Rigidbody doorRigidbody;
    [SerializeField] private Transform openTransform;
    [SerializeField] private Transform closeTransform;
    [SerializeField] private float speed = 1.0f;
    [SerializeField] private bool bIsOpen;
    [SerializeField] private string movingSound = "event:/HideAndSeekDemo/HideAndSeekDemo_MetalDoor";
    [SerializeField] private bool bMovingSoundTriggerCue;
    [SerializeField] private string finishedMovingSound;
    [SerializeField] private ModTouchButton[] buttons;

    private Coroutine serverSimulateDoorCoroutine;
    private ModEventInstance movingInstance;

    protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
    {
        base.ModRegisterRPCs(modNetworkObject);

        RPC_CLIENT_SET_DOOR_OPEN = modNetworkObject.RegisterRPC(ClientSetDoorOpen);
        RPC_CLIENT_SET_DOOR_MOVING = modNetworkObject.RegisterRPC(ClientSetDoorMoving);
    }

    protected override void ModNetworkStart(ModNetworkObject modNetworkObject)
    {
        base.ModNetworkStart(modNetworkObject);

        ServerSetDoorOpen(bIsOpen, true);

        if(buttons != null)
		{
            foreach(ModTouchButton button in buttons)
			{
                if(button)
				{
                    button.onButtonPressed.AddListener(ServerToggleDoor);
				}
			}
		}
    }

    protected override void ModOnDestroy()
    {
        base.ModOnDestroy();

        if(movingInstance.IsValid())
        {
            movingInstance.Stop(MOD_STOP_MODE.IMMEDIATE);
            movingInstance.Release();
        }
    }

    public void ServerToggleDoor()
    {
        ServerSetDoorOpen(!bIsOpen);
    }

    public void ServerOpenSeekerDoor()
    {
        ServerSetDoorOpen(true);
    }

    public void ServerSetDoorOpen(bool bIsOpen, bool bForced = false)
    {
        if (this.bIsOpen == bIsOpen && !bForced) return;
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        if (serverSimulateDoorCoroutine != null)
        {
            StopCoroutine(serverSimulateDoorCoroutine);
        }

        serverSimulateDoorCoroutine = StartCoroutine(DoorSimulate(bIsOpen ? openTransform : closeTransform));

        modNetworkObject.SendRPC(RPC_CLIENT_SET_DOOR_OPEN, true, ModRPCRecievers.AllBuffered, bIsOpen);
    }

    void SetDoorOpen_Internal(bool bIsOpen)
    {
        this.bIsOpen = bIsOpen;
    }

    IEnumerator DoorSimulate(Transform targetTransform)
    {
        float distanceToTarget = Vector3.Distance(targetTransform.position, doorRigidbody.position);
        float timeTillReached = distanceToTarget / speed;

        float time = Time.fixedTime;
        float lerp = 0;

        Vector3 startPosition = doorRigidbody.position;

        WaitForFixedUpdate fixedUpdate = new WaitForFixedUpdate();

        if (buttons != null)
        {
            foreach (ModTouchButton button in buttons)
            {
                if (button)
                {
                    button.ServerSetButtonOn(false);
                }
            }
        }

        ServerSetDoorMoving(true);

        while (lerp <= 1.0f)
        {
            yield return fixedUpdate;

            lerp = (Time.fixedTime - time) / timeTillReached;

            Vector3 position = Vector3.Lerp(startPosition, targetTransform.position, lerp);

            doorRigidbody.MovePosition(position);
        }

        if (buttons != null)
        {
            foreach (ModTouchButton button in buttons)
            {
                if (button)
                {
                    button.ServerSetButtonOn(true);
                }
            }
        }

        ServerSetDoorMoving(false);
    }

    void ServerSetDoorMoving(bool bMoving)
    {
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        modNetworkObject.SendRPC(RPC_CLIENT_SET_DOOR_MOVING, true, ModRPCRecievers.OthersBuffered,ModNetworkManager.Instance.GetTimestep(), bMoving);

        SetDoorMoving(bMoving);
    }

    void SetDoorMoving(bool bMoving)
    {
        if(bMoving)
        {
            if(!movingInstance.IsValid() && !string.IsNullOrEmpty(movingSound))
            {
                movingInstance = ModRuntimeManager.CreateInstance(movingSound);
                ModRuntimeManager.AttachInstanceToGameObject(movingInstance, doorRigidbody.transform, doorRigidbody);
                movingInstance.Start();
            }
        }
        else
        {
            if(!string.IsNullOrEmpty(finishedMovingSound))
            {
                ModRuntimeManager.PlayOneShot(finishedMovingSound, doorRigidbody.transform.position);
            }

            if(movingInstance.IsValid())
            {
                if(bMovingSoundTriggerCue)
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

    void ClientSetDoorOpen(ModNetworkReader reader, ModRPCInfo info)
    {
        if (!info.sender.IsHost) return;

        SetDoorOpen_Internal(reader.ReadBoolean());
    }

	#endregion
}
