using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using ModWobblyLife.Network;

public class ModTrashForce : ModNetworkBehaviour
{
	[SerializeField] private float force = 50.0f;

	private List<ModDynamicObject> dynamicObjects = new List<ModDynamicObject>();
	private Dictionary<ModDynamicObject, int> dynamicObjectsDic = new Dictionary<ModDynamicObject, int>();

	void OnTriggerEnter(Collider other)
	{
		ModDynamicObject dynamicObject = other.GetComponent<ModDynamicObject>();
		if (!dynamicObject)
			dynamicObject = other.GetComponentInParent<ModDynamicObject>();

		if(dynamicObject)
		{
			if(dynamicObjectsDic.ContainsKey(dynamicObject))
			{
				dynamicObjectsDic[dynamicObject]++;
			}
			else
			{
				dynamicObjectsDic.Add(dynamicObject, 1);
				dynamicObjects.Add(dynamicObject);
			}
		}
	}

	void OnTriggerExit(Collider other)
	{
		ModDynamicObject dynamicObject = other.GetComponent<ModDynamicObject>();
		if (!dynamicObject)
			dynamicObject = other.GetComponentInParent<ModDynamicObject>();

		if (dynamicObject)
		{
			if (dynamicObjectsDic.ContainsKey(dynamicObject))
			{
				int count = --dynamicObjectsDic[dynamicObject];
				if(count == 0)
				{
					dynamicObjectsDic.Remove(dynamicObject);
					dynamicObjects.Remove(dynamicObject);
				}
			}
		}
	}

	void FixedUpdate()
	{
		if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

		foreach(ModDynamicObject dynamicObject in dynamicObjects)
		{
			Rigidbody rigidbody = dynamicObject.GetComponent<Rigidbody>();
			if(rigidbody)
			{
				rigidbody.AddForce(transform.forward * force * rigidbody.mass, ForceMode.Impulse);
			}
		}
	}
}
