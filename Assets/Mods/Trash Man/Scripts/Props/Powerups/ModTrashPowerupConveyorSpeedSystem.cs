using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using ModWobblyLife.Network;
using System;

public class ModTrashPowerupConveyorSpeedSystem : ModTrashPowerupBehaviour
{
    [SerializeField] private ModConveyorBeltPlatform[] conveyorBeltPlatforms;
    [SerializeField] private ModTouchButton[] buttons;
    [SerializeField] private float cooldownSeconds = 30.0f;
    [SerializeField] private float lastForSeconds = 5.0f;
    [SerializeField] private float conveyorMulSpeed = 2.0f;

    public override void ServerActivate()
    {
        OnButtonPressed();
    }

    protected override void ModNetworkStart(ModNetworkObject modNetworkObject)
    {
        base.ModNetworkStart(modNetworkObject);

        if (modNetworkObject.IsServer())
        {
            if (buttons != null)
            {
                foreach (ModTouchButton touchButton in buttons)
                {
                    if (touchButton)
                    {
                        touchButton.onButtonPressed.AddListener(OnButtonPressed);
                    }
                }
            }
        }
    }

    void OnButtonPressed()
    {
        StartCoroutine(ServerSystem());
    }

    IEnumerator ServerSystem()
    {
        float[] previousSpeeds = new float[conveyorBeltPlatforms.Length];

        for (int i = 0; i < previousSpeeds.Length; ++i)
        {
            if (conveyorBeltPlatforms[i])
            {
                previousSpeeds[i] = conveyorBeltPlatforms[i].GetSpeed();
            }
        }

        if (buttons != null)
        {
            foreach (ModTouchButton touchButton in buttons)
            {
                if (touchButton)
                {
                    touchButton.ServerSetButtonOn(false);
                }
            }
        }

        for (int i = 0; i < previousSpeeds.Length; ++i)
        {
            if (conveyorBeltPlatforms[i])
            {
                conveyorBeltPlatforms[i].SetSpeed(previousSpeeds[i] * conveyorMulSpeed);
            }
        }

        yield return new WaitForSeconds(lastForSeconds);

        for (int i = 0; i < previousSpeeds.Length; ++i)
        {
            if (conveyorBeltPlatforms[i])
            {
                conveyorBeltPlatforms[i].SetSpeed(previousSpeeds[i]);
            }
        }

        yield return new WaitForSeconds(cooldownSeconds);

        if (buttons != null)
        {
            foreach (ModTouchButton touchButton in buttons)
            {
                if (touchButton)
                {
                    touchButton.ServerSetButtonOn(true);
                }
            }
        }
    }

    public override float GetDuration()
    {
        return lastForSeconds;
    }
}
