using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using ModWobblyLife.Network;
using System;
using ModWobblyLife.Audio;

[DisallowMultipleComponent]
public class ModTrashDynamicObject : ModNetworkSubBehaviour
{
    private byte RPC_CLIENT_CRUSH;

    [SerializeField] private ModTrashBaseParticle destroyParticlePrefab;
    [SerializeField] private string playOneshotOnDestroy;

    protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
    {
        base.ModRegisterRPCs(modNetworkObject);

        RPC_CLIENT_CRUSH = modNetworkObject.RegisterRPC(ClientPlayDestroyParticle);
    }

    public void ServerCrush()
    {
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;
        if (!gameObject.activeInHierarchy) return;

        modNetworkObject.SendRPC(RPC_CLIENT_CRUSH, ModRPCRecievers.All,transform.position);

        gameObject.SetActive(false);

        // Give a little bit of time so the rpc reaches the client before it has been destroyed
        modNetworkObject.Destroy(0.3f);
    }

    #region RPC Callbacks

    void ClientPlayDestroyParticle(ModNetworkReader reader, ModRPCInfo info)
    {
        Vector3 position = reader.ReadVector3();

        if(destroyParticlePrefab)
        {
            ModTrashParticleManager.Instance.PopPlayPush(destroyParticlePrefab, position, transform.rotation);
        }

        if(!string.IsNullOrEmpty(playOneshotOnDestroy))
        {
            ModRuntimeManager.PlayOneShot(playOneshotOnDestroy, position);
        }

        gameObject.SetActive(false);
    }

    #endregion
}
