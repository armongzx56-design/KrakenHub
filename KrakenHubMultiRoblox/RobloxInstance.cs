using System.Diagnostics;

namespace KrakenHubMultiRoblox;

public class RobloxInstance : IDisposable
{
    public int Id { get; }
    public Process? Process { get; set; }
    public DateTime? StartedAt { get; set; }

    public bool IsRunning
    {
        get
        {
            try { return Process is { HasExited: false }; }
            catch { return false; }
        }
    }

    public RobloxInstance(int id) => Id = id;

    public void ReleaseProcessReference()
    {
        try { Process?.Dispose(); } catch { }
        Process = null;
    }

    public void Dispose()
    {
        // Manager cleanup must not kill Roblox.
        ReleaseProcessReference();
    }
}