using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using ModWobblyLife.Network;
using System;
using ModWobblyLife.Audio;

public class ModTrashSlidingDoor : ModNetworkBehaviour
{
    private byte RPC_CLIENT_SET_DOOR_OPEN;

    [SerializeField] private Rigidbody doorRigidbody;
    [SerializeField] private Transform openTransform;
    [SerializeField] private Transform closeTransform;
    [SerializeField] private float speed = 1.0f;
    [SerializeField] private bool bIsOpen;
    [SerializeField] private string doorCloseSound;
    [SerializeField] private string doorOpenSound;

    private Coroutine serverSimulateDoorCoroutine;

    protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
    {
        base.ModRegisterRPCs(modNetworkObject);

        RPC_CLIENT_SET_DOOR_OPEN = modNetworkObject.RegisterRPC(ClientSetDoorOpen);
    }

    protected override void ModNetworkStart(ModNetworkObject modNetworkObject)
    {
        base.ModNetworkStart(modNetworkObject);

        ServerSetDoorOpen(bIsOpen,false,true);
    }

    public void ServerToggleDoor()
    {
        ServerSetDoorOpen(!bIsOpen);
    }

    public void ServerSetDoorOpen(bool bIsOpen,bool bPlaySound = true,bool bForced = false)
    {
        if (this.bIsOpen == bIsOpen && !bForced) return;
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        if(serverSimulateDoorCoroutine != null)
        {
            StopCoroutine(serverSimulateDoorCoroutine);
        }

        serverSimulateDoorCoroutine = StartCoroutine(DoorSimulate(bIsOpen ? openTransform : closeTransform));

        modNetworkObject.SendRPC(RPC_CLIENT_SET_DOOR_OPEN, true, ModRPCRecievers.AllBuffered, bIsOpen, bPlaySound);
    }

    void SetDoorOpen_Internal(bool bIsOpen,bool bPlaySound = true)
    {
        this.bIsOpen = bIsOpen;

        if(bIsOpen)
		{
            if (!string.IsNullOrEmpty(doorOpenSound) && bPlaySound)
            {
                ModRuntimeManager.PlayOneShotAttached(doorOpenSound, doorRigidbody.gameObject);
            }
		}
        else
		{
            if (!string.IsNullOrEmpty(doorCloseSound) && bPlaySound)
            {
                ModRuntimeManager.PlayOneShotAttached(doorCloseSound, doorRigidbody.gameObject);
            }
        }
    }

    IEnumerator DoorSimulate(Transform targetTransform)
    {
        float distanceToTarget = Vector3.Distance(targetTransform.position, doorRigidbody.position);
        float timeTillReached = distanceToTarget / speed;

        float time = Time.time;
        float lerp = 0;

        Vector3 startPosition = doorRigidbody.position;

        WaitForFixedUpdate fixedUpdate = new WaitForFixedUpdate();

        while(lerp <= 1.0f)
        {
            yield return fixedUpdate;

            lerp = (Time.time - time) / timeTillReached;

            Vector3 position = Vector3.Lerp(startPosition, targetTransform.position, lerp);

            doorRigidbody.MovePosition(position);
        }
    }

    #region RPC Callbacks

    void ClientSetDoorOpen(ModNetworkReader reader, ModRPCInfo info)
    {
        if (!info.sender.IsHost) return;

        SetDoorOpen_Internal(reader.ReadBoolean(), reader.ReadBoolean());
    }

    #endregion
}
