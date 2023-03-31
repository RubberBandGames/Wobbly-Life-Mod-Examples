using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife.UI;
using ModWobblyLife.Audio;

public class ModUIPlayerBasedTrashInstructions : ModUIPlayerBasedCanvas
{
    [SerializeField] private GameObject trashManInstructions;
    [SerializeField] private GameObject garbageInstructions;
    [SerializeField] private string soundOneshotOnShow;

    public void ShowTrashManInstructions()
    {
        if (!string.IsNullOrEmpty(soundOneshotOnShow))
        {
            ModRuntimeManager.PlayOneShot(soundOneshotOnShow);
        }

        if (trashManInstructions)
        {
            trashManInstructions.SetActive(true);
        }

        if(garbageInstructions)
        {
            garbageInstructions.SetActive(false);
        }
    }

    public void ShowGarbageInstructions()
    {
        if (!string.IsNullOrEmpty(soundOneshotOnShow))
        {
            ModRuntimeManager.PlayOneShot(soundOneshotOnShow);
        }

        if (garbageInstructions)
        {
            garbageInstructions.SetActive(true);
        }

        if (trashManInstructions)
        {
            trashManInstructions.SetActive(false);
        }
    }
}
