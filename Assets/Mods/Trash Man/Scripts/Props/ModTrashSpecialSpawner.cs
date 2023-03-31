using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using ModWobblyLife.Network;
using System;
using Random = UnityEngine.Random;
using ModWobblyLife.Audio;

public class ModTrashSpecialSpawner : ModNetworkBehaviour
{
	private byte RPC_CLIENT_PLAY_SPAWNING_SOUND;

	[SerializeField] private Transform[] potentialSpawnPoints;
	[SerializeField] private GameObject[] dynamicObjectPrefabs;
	[SerializeField] private string spawningSound;
	[SerializeField] private Transform overrideSpawningSoundTransform;

	private Coroutine serverSpawnerUpdateCoroutine;

	protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
	{
		base.ModRegisterRPCs(modNetworkObject);

		RPC_CLIENT_PLAY_SPAWNING_SOUND = modNetworkObject.RegisterRPC(ClientPlaySpawningSound);
	}

	public void ServerTurnOnSpecialSpawner(float spawnRateSeconds = 1.0f)
	{
		if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

		if (serverSpawnerUpdateCoroutine != null)
		{
			StopCoroutine(serverSpawnerUpdateCoroutine);
		}

		serverSpawnerUpdateCoroutine = StartCoroutine(ServerSpawnerUpdate(spawnRateSeconds));
	}

	public void ServerTurnOffSpecialSpawner()
	{
		if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

		if (serverSpawnerUpdateCoroutine != null)
		{
			StopCoroutine(serverSpawnerUpdateCoroutine);
		}
	}

	IEnumerator ServerSpawnerUpdate(float spawnRateSeconds = 1.0f)
	{
		WaitForSeconds seconds = new WaitForSeconds(spawnRateSeconds);

		modNetworkObject.SendRPC(RPC_CLIENT_PLAY_SPAWNING_SOUND, ModRPCRecievers.All);

		while (true)
		{
			yield return seconds;

			ServerSpawnDynamicObject();
		}
	}

	void ServerSpawnDynamicObject()
	{
		if (potentialSpawnPoints == null || potentialSpawnPoints.Length == 0) return;
		if (dynamicObjectPrefabs == null || dynamicObjectPrefabs.Length == 0) return;

		Transform spawnPoint = potentialSpawnPoints[Random.Range(0, potentialSpawnPoints.Length)];
		GameObject prefab = dynamicObjectPrefabs[Random.Range(0, dynamicObjectPrefabs.Length)];

		if (spawnPoint && prefab)
		{
			ModNetworkManager.Instance.InstantiateNetworkPrefab(prefab, null, spawnPoint.position, spawnPoint.rotation, null, true);
		}
	}

	#region RPC Callbacks

	void ClientPlaySpawningSound(ModNetworkReader reader, ModRPCInfo info)
	{
		if (!string.IsNullOrEmpty(spawningSound))
		{
			if(!overrideSpawningSoundTransform)
			{
				overrideSpawningSoundTransform = transform;
			}

			ModRuntimeManager.PlayOneShot(spawningSound, overrideSpawningSoundTransform.position);
		}
	}

	#endregion
}
