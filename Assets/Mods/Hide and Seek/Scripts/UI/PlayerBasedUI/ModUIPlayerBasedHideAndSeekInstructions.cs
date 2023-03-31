using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife.UI;
using ModWobblyLife.Audio;

public class ModUIPlayerBasedHideAndSeekInstructions : ModUIPlayerBasedCanvas
{
    [SerializeField] private GameObject seekerInstructions;
    [SerializeField] private GameObject hiderInstructions;
    [SerializeField] private string soundOneshotOnShow;

    public void ShowSeekerInstructions()
    {
        if (!string.IsNullOrEmpty(soundOneshotOnShow))
        {
            ModRuntimeManager.PlayOneShot(soundOneshotOnShow);
        }

        if (seekerInstructions)
        {
            seekerInstructions.SetActive(true);
        }

        if (hiderInstructions)
        {
            hiderInstructions.SetActive(false);
        }
    }

    public void ShowHidersInstructions()
    {
        if (!string.IsNullOrEmpty(soundOneshotOnShow))
        {
            ModRuntimeManager.PlayOneShot(soundOneshotOnShow);
        }

        if (hiderInstructions)
        {
            hiderInstructions.SetActive(true);
        }

        if (seekerInstructions)
        {
            seekerInstructions.SetActive(false);
        }
    }
}
