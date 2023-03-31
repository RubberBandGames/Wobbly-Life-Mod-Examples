using ModWobblyLife;
using ModWobblyLife.Network;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModHideExplosionParticle : ModHideBaseParticle
{
	[SerializeField] private float explosionRadius = 10.0f;
	[SerializeField] private float explosionPower = 50.0f;

	protected override void OnPlay()
	{
		base.OnPlay();

		// As the server is the only one who deal with the physics
		if (ModNetworkManager.Instance.IsServer())
		{
			Collider[] colliders = Physics.OverlapSphere(transform.position, explosionRadius);

			foreach (Collider hit in colliders)
			{
				if (transform.IsChildOf(hit.transform))
					continue;

				Hit(hit);
			}
		}
	}

	protected virtual void Hit(Collider hit)
	{
		if (explosionPower > 0.0f)
		{
			ExplodeData data = new ExplodeData();
			data.position = transform.position;
			data.force = explosionPower;
			data.radius = explosionRadius;
			data.explodeGameObject = gameObject;

			IModExplode[] explodes = hit.GetComponentsInParent<IModExplode>(false);

			foreach (IModExplode explode in explodes)
			{
				explode.Explode(data);
			}
		}
	}

	void OnDrawGizmosSelected()
	{
		Gizmos.color = Color.red;
		Gizmos.DrawWireSphere(transform.position, explosionRadius);
	}
}
