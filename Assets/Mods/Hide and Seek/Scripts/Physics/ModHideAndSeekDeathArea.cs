using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;

public class ModHideAndSeekDeathArea : MonoBehaviour
{
	void OnTriggerEnter(Collider other)
	{
		ModPlayerCharacter playerCharacter = other.GetComponentInParent<ModPlayerCharacter>();
		if(playerCharacter)
		{
			playerCharacter.Kill();
		}
	}
}
