using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using ModWobblyLife.Network;
using System;

public class ModHideAndSeekExplosionBarrel : ModDynamicObject,IModExplode
{
	private byte RPC_CLIENT_START_EXPLOSION_COUNTDOWN;
	private byte RPC_CLIENT_EXPLODE;

	[SerializeField] private ModHideExplosionParticle explosionParticlePrefab;
	[SerializeField] private float defaultFuseTime = 3.0f;
	[SerializeField] private AnimationCurve animationCurve;
	[SerializeField] private Material explodeMaterial;
	[SerializeField] private MeshRenderer renderer;
	[SerializeField][GradientUsage(true)] private Gradient emissionGradient;

	private bool bStartedCountdown;

	protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
	{
		base.ModRegisterRPCs(modNetworkObject);

		RPC_CLIENT_START_EXPLOSION_COUNTDOWN = modNetworkObject.RegisterRPC(ClientStartExplosionCountdown);
		RPC_CLIENT_EXPLODE = modNetworkObject.RegisterRPC(ClientExplode);
	}


	public void Explode(ExplodeData data)
	{
		if (bStartedCountdown) return;
		if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

		float fuseTime = data.radius * 0.1f;

		Explode(fuseTime);
	}

	void Explode(float fuseTime)
	{
		if (bStartedCountdown) return;

		ulong startTimestep = ModNetworkManager.Instance.GetTimestep();
		ulong endTimestep = startTimestep + (ulong)(fuseTime * 1000.0f);

		modNetworkObject.SendRPC(RPC_CLIENT_START_EXPLOSION_COUNTDOWN, true, ModRPCRecievers.AllBuffered, startTimestep, endTimestep);

		IEnumerator Delay()
		{
			yield return new WaitForSeconds(fuseTime);

			modNetworkObject.SendRPC(RPC_CLIENT_EXPLODE, ModRPCRecievers.All);
			// Destroys object after X time so that the previous RPC has enough time to activate i.e shows the explode particle on the clients side
			modNetworkObject.Destroy(1.0f);
		}

		StartCoroutine(Delay());
	}

	void OnCollisionEnter(Collision collision)
	{
		if (bStartedCountdown) return;

		ModPlayerCharacter character = collision.collider.GetComponentInParent<ModPlayerCharacter>();
		if(character)
		{
			Explode(defaultFuseTime);
		}
	}

	IEnumerator ExplodeAnimation(ulong startTimestep,ulong endTimestep)
	{
		float lerp = 0.0f;

		float seconds = (endTimestep - startTimestep) / 1000.0f;

		Material material = new Material(explodeMaterial);

		renderer.sharedMaterial = material;
		material.SetColor("_EmissionColor", emissionGradient.Evaluate(0.0f));

		while (lerp <= 1.0f)
		{
			yield return null;

			if (startTimestep < ModNetworkManager.Instance.GetTimestep())
			{
				ulong duration = ModNetworkManager.Instance.GetTimestep() - startTimestep;

				lerp = (duration / 1000.0f) / seconds;

				float emissionValue = animationCurve.Evaluate(lerp);

				//Debug.LogError("Lerp: " + lerp + "  Emission: " + emissionValue);

				Color color = emissionGradient.Evaluate(emissionValue);

				material.SetColor("_EmissionColor", color);
			}
		}
	}

	#region RPC Callbacks

	void ClientExplode(ModNetworkReader reader, ModRPCInfo info)
	{
		if (gameObject.activeInHierarchy)
		{
			if (explosionParticlePrefab)
			{
				ModHideParticleManager.Instance.PopPlayPush(explosionParticlePrefab, transform.position, transform.rotation);
			}

			gameObject.SetActive(false);
		}
	}

	void ClientStartExplosionCountdown(ModNetworkReader reader, ModRPCInfo info)
	{
		if (!info.sender.IsHost) return;

		bStartedCountdown = true;

		ulong startTimestep = reader.ReadUInt64();
		ulong endTimestep = reader.ReadUInt64();

		StartCoroutine(ExplodeAnimation(startTimestep, endTimestep));
	}

	#endregion
}
