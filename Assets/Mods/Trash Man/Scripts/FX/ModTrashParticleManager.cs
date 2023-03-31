using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModTrashParticleManager : MonoBehaviour
{
    private static ModTrashParticleManager instance;
    private static bool bApplicationQuit;

    public static ModTrashParticleManager Instance
    {
        get
        {
            if (bApplicationQuit)
                return instance;

            if(!instance)
            {
                GameObject gameObject = new GameObject("ParticleManager");
                instance = gameObject.AddComponent<ModTrashParticleManager>();
            }

            return instance;
        }
    }

    void Awake()
    {
        if(instance != this && instance)
        {
            Debug.LogWarning("Destroying duplicate ParticleManager");
            Destroy(gameObject);
            return;
        }

        instance = this;
    }

    private Dictionary<int, List<ModTrashBaseParticle>> avaliableParticles = new Dictionary<int, List<ModTrashBaseParticle>>();

    public void PopPlayPush(ModTrashBaseParticle prefab, Vector3 position, Quaternion rotation, float scale = 1.0f)
    {
        PopPlayPush(prefab, position, rotation, Vector3.one * scale);
    }

    public void PopPlayPush(ModTrashBaseParticle prefab, Vector3 position, Quaternion rotation, Vector3 scale)
    {
        ModTrashBaseParticle instance = Pop(prefab);
        instance.transform.SetPositionAndRotation(position, rotation);
        instance.transform.localScale = scale;
        instance.Play();
        Push(prefab, instance);
    }

    public ModTrashBaseParticle Pop(ModTrashBaseParticle prefab)
    {
        ModTrashBaseParticle instance = null;

        if (prefab)
        {
            int id = prefab.GetInstanceID();
            if (avaliableParticles.TryGetValue(id, out List<ModTrashBaseParticle> allocated))
            {
                for (int i = 0; i < allocated.Count; ++i)
                {
                    if (!allocated[i].IsPlaying())
                    {
                        instance = allocated[i];
                        allocated.RemoveAt(i);

                        if (allocated.Count == 0)
                            avaliableParticles.Remove(id);

                        break;
                    }
                }
            }

            if (!instance)
            {
                instance = Instantiate(prefab, transform);
            }
        }

        return instance;
    }

    public void Push(ModTrashBaseParticle prefab, ModTrashBaseParticle instance)
    {
        if (prefab)
        {
            int id = prefab.GetInstanceID();

            instance.transform.parent = transform;

            if (avaliableParticles.TryGetValue(id, out List<ModTrashBaseParticle> allocated))
            {
                allocated.Add(instance);
            }
            else
            {
                List<ModTrashBaseParticle> baseParticles = new List<ModTrashBaseParticle>();
                baseParticles.Add(instance);
                avaliableParticles.Add(id, baseParticles);
            }
        }
    }

    void OnApplicationQuit()
    {
        bApplicationQuit = true;
    }
}
