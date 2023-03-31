using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using ModWobblyLife.Audio;
using System;

[DisallowMultipleComponent]
public class ModTrashBaseParticle : MonoBehaviour
{
    [SerializeField] private string playEvent;
    [SerializeField] private bool bOneshot;
    [SerializeField] private bool bPlayOnAwake;
    [SerializeField] private bool bRestartParticleOnPlay;
    [SerializeField] private bool bAllowAliveParticles = false;

    private ParticleSystem[] particleSystems;
    private ModEventInstance eventInstance;
    private float timeSincePlayed;
    private float longest;
    private bool bPlaying;

    protected virtual void Awake()
    {
        if (bPlayOnAwake)
        {
            Play();
        }
    }

    protected virtual void OnDestroy()
    {
        if (eventInstance.IsValid())
        {
            eventInstance.Stop(MOD_STOP_MODE.ALLOWFADEOUT);
            eventInstance.Release();
            eventInstance.ClearHandle();
        }
    }

    public void Play()
    {
        Play(null);
    }

    public virtual void Play(Action<ModEventInstance> onPrePlaySound = null)
    {
        if (bPlaying && !bOneshot) return;

        if (eventInstance.IsValid())
        {
            Stop();
        }

        timeSincePlayed = Time.time;
        bPlaying = true;

        if (playEvent != null && playEvent.Length > 0)
        {
            eventInstance = ModRuntimeManager.CreateInstance(playEvent);

            if (eventInstance.IsValid())
            {
                onPrePlaySound?.Invoke(eventInstance);
                ModRuntimeManager.AttachInstanceToGameObject(eventInstance, transform, GetComponent<Rigidbody>());
                eventInstance.Start();

                if (bOneshot)
                {
                    eventInstance.Release();
                    eventInstance.ClearHandle();
                }
            }
        }

        if (particleSystems == null)
            particleSystems = GetComponentsInChildren<ParticleSystem>();

        foreach (ParticleSystem particleSystem in particleSystems)
        {
            if (!bRestartParticleOnPlay)
            {
                if (!particleSystem.isPlaying || bAllowAliveParticles)
                {
                    particleSystem.Play(false);
                }

                ParticleSystem.EmissionModule module = particleSystem.emission;
                module.enabled = true;
            }
            else
            {
                particleSystem.Clear(false);
                particleSystem.Play(false);
            }
        }

        OnPlay();
    }

    protected virtual void OnPlay()
    {

    }

    public virtual void Stop()
    {
        if (!bPlaying) return;

        bPlaying = false;

        if (eventInstance.IsValid())
        {
            eventInstance.Stop(MOD_STOP_MODE.ALLOWFADEOUT);
            eventInstance.Release();
            eventInstance.ClearHandle();
        }

        if (particleSystems == null)
            particleSystems = GetComponentsInChildren<ParticleSystem>();

        foreach (ParticleSystem particleSystem in particleSystems)
        {
            if (!bRestartParticleOnPlay)
            {
                ParticleSystem.EmissionModule module = particleSystem.emission;
                module.enabled = false;
            }
            else
            {
                particleSystem.Stop();
            }
        }

        OnStop();
    }

    protected virtual void OnStop()
    {

    }

    public virtual void PlayAndDestroy()
    {
        gameObject.transform.parent = null;
        gameObject.transform.gameObject.SetActive(true);

        Play();

        float longest = GetLongestDuration();

        Destroy(gameObject, longest + 1.0f);

    }

    public float GetLongestDuration()
    {
        if (longest == 0.0f)
        {
            if (particleSystems == null)
                particleSystems = GetComponentsInChildren<ParticleSystem>();

            foreach (ParticleSystem particleSystem in particleSystems)
            {
                if (particleSystem.main.duration > longest)
                {
                    longest = particleSystem.main.duration;
                }
            }
        }

        return longest;
    }

    public bool IsPlaying()
    {
        if (particleSystems == null)
            particleSystems = GetComponentsInChildren<ParticleSystem>();

        float longestDuration = GetLongestDuration() + 0.1f;

        for (int i = 0; i < particleSystems.Length; ++i)
        {
            ParticleSystem particleSystem = particleSystems[i];

            ParticleSystem.EmissionModule module = particleSystem.emission;

            if (particleSystem.isPlaying && module.enabled)
            {
                return true;
            }
        }

        if (bPlaying)
        {
            if (Time.time - timeSincePlayed >= longestDuration)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        return false;
    }

    public bool IsAlive()
    {
        if (particleSystems == null)
            particleSystems = GetComponentsInChildren<ParticleSystem>();

        if (!bAllowAliveParticles)
        {
            foreach (ParticleSystem particleSystem in particleSystems)
            {
                if (particleSystem.IsAlive(false))
                {
                    return true;
                }
            }
        }

        return false;
    }

    public ParticleSystem[] GetParticleSystems()
    {
        if (particleSystems == null)
            particleSystems = GetComponentsInChildren<ParticleSystem>();

        return particleSystems;
    }
}
