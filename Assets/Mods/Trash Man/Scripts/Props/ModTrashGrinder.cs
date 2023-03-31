using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using ModWobblyLife.Network;

public class ModTrashGrinder : ModNetworkBehaviour
{
    private void OnCollisionEnter(Collision collision)
    {
        ModDynamicObject modDynamicObject = collision.gameObject.GetComponent<ModDynamicObject>();
        if (modDynamicObject && modDynamicObject.modNetworkObject != null)
        {
            ModTrashDynamicObject trashDynamicObject = modDynamicObject.GetComponent<ModTrashDynamicObject>();

            if (trashDynamicObject)
            {
                trashDynamicObject.ServerCrush();
            }
            else
            {
                modDynamicObject.modNetworkObject.Destroy();
            }
        }
    }
}
