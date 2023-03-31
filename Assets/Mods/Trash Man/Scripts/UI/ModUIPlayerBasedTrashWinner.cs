using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using ModWobblyLife.UI;

public class ModUIPlayerBasedTrashWinner : ModUIPlayerBasedCanvas
{
    [SerializeField] private TMPro.TextMeshProUGUI text;

    public void SetWinner(TrashWinner winner)
    {
        switch(winner)
        {
            case TrashWinner.TrashMan:
                {
                    if(text)
                    {
                        text.text = "Trash Man Wins!";
                    }
                }
                break;
            case TrashWinner.Garbage:
                {
                    if (text)
                    {
                        text.text = "Garbage Wins!";
                    }
                }
                break;
        }
    }
}
