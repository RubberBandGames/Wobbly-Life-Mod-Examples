using ModWobblyLife;
using ModWobblyLife.Audio;
using ModWobblyLife.Network;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModConveyorBeltPlatform : ModPlatform,IModGrabbable
{
	public Action<bool> onConveyorBeltOnChanged;
	public Action<float> onConveyorBeltCurrentSpeedChanged;
	public Action<float> onConveyorBeltSpeedChanged;

	[SerializeField] private float speed = 1;
	[SerializeField] private bool bIsOn = true;
	[SerializeField] private float acceleration = 0.5f;
	[SerializeField] private string sound = "event:/TrashManDemo/TrashManDemo_ConveyerBelt";
	[SerializeField] private float visualSpeedScaler = 0.045f;

	private Material material;
	private float currentSpeed;

	private ModEventInstance soundInstance;

    protected override void ModAwake()
    {
        base.ModAwake();

		Renderer renderer = GetComponent<Renderer>();
		if (renderer)
		{
			material = renderer.material;
		}
	}


    void Reset()
	{
		Rigidbody rigidbody = GetComponent<Rigidbody>();

		if (rigidbody)
		{
			rigidbody.isKinematic = true;
		}

		if (!GetComponent<ModConveyorBeltPlatformNetwork>())
		{
			gameObject.AddComponent<ModConveyorBeltPlatformNetwork>();
		}
	}

	void OnDestroy()
	{
		if (soundInstance.IsValid())
		{
			soundInstance.Stop(MOD_STOP_MODE.IMMEDIATE);
			soundInstance.Release();
		}
	}

	void Update()
	{
		if (bIsOn)
		{
			SetCurrentSpeed(Mathf.MoveTowards(currentSpeed, speed, acceleration * Time.deltaTime));
		}
		else
		{
			SetCurrentSpeed(Mathf.MoveTowards(currentSpeed, 0, acceleration * Time.deltaTime));
		}

		if (material)
		{
			material.mainTextureOffset += -Vector2.up * currentSpeed * visualSpeedScaler * Time.deltaTime;
		}
	}

	void SetSoundCurrentSpeed(float currentSpeed)
	{
		if (enabled)
		{
			if (!soundInstance.IsValid())
			{
				if (!string.IsNullOrEmpty(sound))
				{
					soundInstance = ModRuntimeManager.CreateInstance(sound);
					if (soundInstance.IsValid())
					{
						ModRuntimeManager.AttachInstanceToGameObject(soundInstance, transform, GetComponent<Rigidbody>());
						soundInstance.Start();
					}
				}
			}
		}
		else
		{
			if (soundInstance.IsValid())
			{
				soundInstance.TriggerCue();
				soundInstance.Release();
				soundInstance.ClearHandle();
			}
		}

		if (soundInstance.IsValid())
		{
			soundInstance.SetParameterByName("Speed", currentSpeed);
		}
	}

	public void Toggle()
	{
		if (!ModNetworkManager.Instance.IsServer()) return;

		SetIsOn(!bIsOn);
	}

	public void SetIsOn(bool bIsOn)
	{
		if (!ModNetworkManager.Instance.IsServer()) return;

		SetIsOn_Internal(bIsOn);
	}

	public void SetIsOn_Internal(bool bIsOn)
	{
		this.bIsOn = bIsOn;

		if (bIsOn)
		{
			enabled = true;
		}

		onConveyorBeltOnChanged?.Invoke(bIsOn);
	}

	#region Getters/Setters

	public override Vector3 GetVelocity()
	{
		return base.GetVelocity() + transform.forward * currentSpeed;
	}

	public void SetSpeed(float speed)
    {
        this.speed = speed;

		onConveyorBeltSpeedChanged?.Invoke(speed);
	}

    public float GetSpeed()
	{
		return speed;
	}

	public void SetCurrentSpeed(float currentSpeed)
	{
		this.currentSpeed = currentSpeed;

		onConveyorBeltCurrentSpeedChanged?.Invoke(currentSpeed);

		enabled = Mathf.Abs(currentSpeed) > 0.01f || bIsOn;
		SetSoundCurrentSpeed(currentSpeed);
	}

	public float GetCurrentSpeed()
	{
		return currentSpeed;
	}

	public bool IsOn()
	{
		return bIsOn;
	}

	public override bool IsPropsSpeedOverridden()
	{
		return true;
	}

    public bool IsGrabbable()
    {
		return false;
    }

    #endregion
}
