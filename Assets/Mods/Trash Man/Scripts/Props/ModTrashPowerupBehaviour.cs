using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife.Network;

public abstract class ModTrashPowerupBehaviour : ModNetworkBehaviour
{
    public abstract void ServerActivate();

    public abstract float GetDuration();
}
