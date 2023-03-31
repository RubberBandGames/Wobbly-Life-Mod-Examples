using ModWobblyLife;
using ModWobblyLife.UI;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ModUIPlayerBasedHideAndSeekPlayerIcon : MonoBehaviour
{
	[SerializeField] private RawImage playerImage;
	[SerializeField] private Image caughtImage;

	private ModHideAndSeekPlayerController controller;

	public void Assign(ModHideAndSeekPlayerController controller)
	{
		if (this.controller) return;

		this.controller = controller;

		OnCaughtChanged(controller, controller.IsCaught());
		controller.onCaughtChanged += OnCaughtChanged;

		if(controller.GetPlayerCharacter())
		{
			OnPlayerCharacterSpawned(controller, controller.GetPlayerCharacter());
		}
		controller.onPlayerCharacterSpawned += OnPlayerCharacterSpawned;
		OnSeekerChanged(controller, controller.IsSeeker());
		controller.onSeekerChanged += OnSeekerChanged;
	}

	void Unassign()
	{
		if(controller)
		{
			controller.onCaughtChanged -= OnCaughtChanged;
			controller.onSeekerChanged -= OnSeekerChanged;

			controller.onPlayerCharacterSpawned -= OnPlayerCharacterSpawned;

			controller = null;
		}
	}

	void OnSeekerChanged(ModPlayerController controller, bool bIsSeeker)
	{
		gameObject.SetActive(!bIsSeeker);
	}

	void OnDestroy()
	{
		Unassign();
	}

	void OnPlayerCharacterSpawned(ModPlayerController modPlayerController, ModPlayerCharacter playerCharacter)
	{
		ModPlayerRenderTextureCamera renderTextureCamera = playerCharacter.GetPlayerRenderTextureCamera();
		if(renderTextureCamera)
		{
			if(playerImage)
			{
				playerImage.texture = renderTextureCamera.GetRenderTexture();
			}
		}
	}

	void OnCaughtChanged(ModPlayerController controller, bool bIsCaught)
	{
		if(caughtImage)
		{
			caughtImage.gameObject.SetActive(bIsCaught);
		}
	}
}
