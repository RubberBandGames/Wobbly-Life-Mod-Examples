using ModWobblyLife.UI;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;

public class ModUIPlayerBasedHideAndSeekGameplayCanvas : ModUIElement
{
    [SerializeField] private TMPro.TextMeshProUGUI timerText;
    [SerializeField] private TMPro.TextMeshProUGUI youAreText;

    private ModHideAndSeekGameTimer gameTimer;

	void SetTimerText(string text)
    {
        if(timerText)
        {
            timerText.text = text;
        }
    }

    public void SetIsSeeker(bool bIsSeeker)
    {
        if(youAreText)
        {
            youAreText.text = bIsSeeker ? "You are: Seeker" : "You are: Hider";
        }
    }

    public void SetTimer(ModHideAndSeekGameTimer gameTimer)
    {
        this.gameTimer = gameTimer;
    }

    void Update()
    {
        if(gameTimer)
        {
            SetTimerText(gameTimer.GetSecondsLeftFormatted());
        }
    }
}
