using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using ModWobblyLife.Network;
using Random = UnityEngine.Random;
using ModWobblyLife.Audio;

[Serializable]
public class ModTrashPowerupMassiveObjectSpawnerSystemData
{
    public GameObject dynamicObjectPrefab;
    public string spawnSoundEvent = "event:/TrashDemo/TrashDemo_MassiveItem";
}

public class ModTrashPowerupMassiveObjectSpawnerSystem : ModTrashPowerupBehaviour
{
    private byte RPC_CLIENT_PLAY_SPAWN_SOUND;

    [SerializeField] private float duration = 20.0f;
    [SerializeField] private ModTrashPowerupMassiveObjectSpawnerSystemData[] dynamicObjectDatas;
    [SerializeField] private Transform[] spawnPoints;

    protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
    {
        base.ModRegisterRPCs(modNetworkObject);

        RPC_CLIENT_PLAY_SPAWN_SOUND = modNetworkObject.RegisterRPC(ClientPlaySpawnSound);
    }

    public override void ServerActivate()
    {
        if (dynamicObjectDatas == null && dynamicObjectDatas.Length == 0)
            return;

        if (spawnPoints == null && spawnPoints.Length == 0)
            return;

        Transform spawnPoint = spawnPoints[Random.Range(0, spawnPoints.Length)];
        int dynamicObjectIndex = Random.Range(0, dynamicObjectDatas.Length);

        ModTrashPowerupMassiveObjectSpawnerSystemData spawnerSystemData = dynamicObjectDatas[dynamicObjectIndex];

        if (spawnPoint && spawnerSystemData.dynamicObjectPrefab)
        {
            ModNetworkManager.Instance.InstantiateNetworkPrefab(spawnerSystemData.dynamicObjectPrefab, x =>
             {
                 modNetworkObject.SendRPC(RPC_CLIENT_PLAY_SPAWN_SOUND, ModRPCRecievers.All, dynamicObjectIndex);

                 if(x)
                 {
                     x.modNetworkObject.Destroy(duration);
                 }
             }, spawnPoint.position, spawnPoint.rotation, null, true);
        }
    }

    #region RPC Callbacks

    void ClientPlaySpawnSound(ModNetworkReader reader, ModRPCInfo info)
    {
        if (!info.sender.IsHost) return;

        int dynamicObjectSpawnIndex = reader.ReadInt32();

        if (dynamicObjectDatas == null || dynamicObjectSpawnIndex >= dynamicObjectDatas.Length)
            return;

        ModTrashPowerupMassiveObjectSpawnerSystemData spawnerSystemData = dynamicObjectDatas[dynamicObjectSpawnIndex];

        if(spawnerSystemData != null)
        {
            if(!string.IsNullOrEmpty(spawnerSystemData.spawnSoundEvent))
            {
                ModRuntimeManager.PlayOneShot(spawnerSystemData.spawnSoundEvent, transform.position);
            }
        }
    }

    #endregion

    public override float GetDuration()
    {
        return duration;
    }
}
