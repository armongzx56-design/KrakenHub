using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Threading;
using Microsoft.Win32;

namespace KrakenHubMultiRoblox;

public partial class MainWindow : Window
{
    private readonly ObservableCollection<RobloxInstance> instances = new();
    private readonly DispatcherTimer monitor = new() { Interval = TimeSpan.FromSeconds(2) };

    [DllImport("user32.dll")] private static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);
    [DllImport("user32.dll")] private static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint processId);
    [DllImport("user32.dll")] private static extern bool IsWindowVisible(IntPtr hWnd);
    [DllImport("user32.dll")] private static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
    [DllImport("user32.dll")] private static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    private delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    public MainWindow()
    {
        InitializeComponent();
        BuildInstances(4);
        monitor.Tick += (_, _) => RefreshStatuses();
        monitor.Start();
    }

    private void BuildInstances(int count)
    {
        foreach (var i in instances) i.Dispose();
        instances.Clear();
        InstancesPanel.Children.Clear();

        for (int n = 1; n <= count; n++)
        {
            var item = new RobloxInstance(n);
            instances.Add(item);
            InstancesPanel.Children.Add(CreateCard(item));
        }
        RefreshStatuses();
    }

    private Border CreateCard(RobloxInstance item)
    {
        var card = new Border
        {
            Background = (Brush)FindResource("Panel2"),
            BorderBrush = (Brush)FindResource("Border"),
            BorderThickness = new Thickness(1),
            CornerRadius = new CornerRadius(10),
            Padding = new Thickness(14),
            Margin = new Thickness(0, 0, 0, 9)
        };

        var grid = new Grid();
        grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
        grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

        var info = new StackPanel();
        var title = new TextBlock { Text = $"Instance #{item.Id}", FontSize = 16, FontWeight = FontWeights.SemiBold };
        var status = new TextBlock { Name = $"Status{item.Id}", Text = "Offline", Foreground = Brushes.Gray, Margin = new Thickness(0, 5, 0, 0) };
        var pid = new TextBlock { Name = $"Pid{item.Id}", Text = "PID —", Foreground = (Brush)FindResource("Muted"), Margin = new Thickness(0, 3, 0, 0) };
        info.Children.Add(title); info.Children.Add(status); info.Children.Add(pid);

        var buttons = new StackPanel { Orientation = Orientation.Horizontal, VerticalAlignment = VerticalAlignment.Center };
        var launch = new Button { Content = "Launch" };
        launch.Click += (_, _) => Launch(item);
        var focus = new Button { Content = "Focus" };
        focus.Click += (_, _) => Focus(item);
        var restart = new Button { Content = "Restart" };
        restart.Click += (_, _) => { Stop(item); Task.Delay(500).ContinueWith(_ => Dispatcher.Invoke(() => Launch(item))); };
        var close = new Button { Content = "Close" };
        close.Click += (_, _) => Stop(item);
        buttons.Children.Add(launch); buttons.Children.Add(focus); buttons.Children.Add(restart); buttons.Children.Add(close);

        grid.Children.Add(info);
        Grid.SetColumn(buttons, 1);
        grid.Children.Add(buttons);
        card.Child = grid;
        return card;
    }

    private void BrowseRunner_Click(object sender, RoutedEventArgs e)
    {
        var dialog = new OpenFileDialog { Filter = "Executable (*.exe)|*.exe|All files (*.*)|*.*" };
        if (dialog.ShowDialog() == true) RunnerPathBox.Text = dialog.FileName;
    }

    private void TestRunner_Click(object sender, RoutedEventArgs e)
    {
        var path = RunnerPathBox.Text.Trim();
        if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
        {
            MessageBox.Show("เลือกไฟล์โปรแกรม Runner (.exe) ก่อน", "Runner");
            return;
        }
        try { Process.Start(new ProcessStartInfo { FileName = path, UseShellExecute = true }); }
        catch (Exception ex) { MessageBox.Show(ex.Message, "Runner launch failed"); }
    }

    private void Launch(RobloxInstance item)
    {
        if (item.Process is { HasExited: false }) return;

        var exe = FindRoblox();
        if (exe == null)
        {
            MessageBox.Show("หา RobloxPlayerBeta.exe ไม่เจอ
เปิด Roblox อย่างน้อย 1 ครั้งก่อน แล้วลองใหม่", "Roblox not found");
            return;
        }

        try
        {
            item.Process = Process.Start(new ProcessStartInfo
            {
                FileName = exe,
                UseShellExecute = true
            });
            item.StartedAt = DateTime.Now;
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Launch failed");
        }
    }

    private static string? FindRoblox()
    {
        var root = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Roblox", "Versions");
        if (!Directory.Exists(root)) return null;

        return Directory.GetDirectories(root)
            .Select(d => Path.Combine(d, "RobloxPlayerBeta.exe"))
            .Where(File.Exists)
            .OrderByDescending(File.GetLastWriteTimeUtc)
            .FirstOrDefault();
    }

    private void Stop(RobloxInstance item)
    {
        try
        {
            if (item.Process is { HasExited: false })
                item.Process.Kill(true);
        }
        catch { }
        item.Process = null;
    }

    private void StopAll_Click(object sender, RoutedEventArgs e) => instances.ToList().ForEach(Stop);
    private void LaunchAll_Click(object sender, RoutedEventArgs e)
    {
        foreach (var item in instances) Launch(item);
        _ = Task.Delay(2500).ContinueWith(_ => Dispatcher.Invoke(ArrangeWindows));
    }
    private void RestartAll_Click(object sender, RoutedEventArgs e)
    {
        StopAll_Click(sender, e);
        _ = Task.Delay(700).ContinueWith(_ => Dispatcher.Invoke(LaunchAll_Click));
    }

    private void Focus(RobloxInstance item)
    {
        var hwnd = FindWindow(item.Process);
        if (hwnd != IntPtr.Zero) ShowWindow(hwnd, 9);
    }

    private IntPtr FindWindow(Process? process)
    {
        if (process == null || process.HasExited) return IntPtr.Zero;
        IntPtr found = IntPtr.Zero;
        EnumWindows((hwnd, _) =>
        {
            GetWindowThreadProcessId(hwnd, out uint pid);
            if (pid == process.Id && IsWindowVisible(hwnd))
            {
                found = hwnd;
                return false;
            }
            return true;
        }, IntPtr.Zero);
        return found;
    }

    private void ArrangeWindows()
    {
        int rows = int.TryParse(RowsBox.Text, out var r) ? Math.Clamp(r, 1, 10) : 2;
        int cols = int.TryParse(ColsBox.Text, out var c) ? Math.Clamp(c, 1, 10) : 2;
        var area = System.Windows.Forms.Screen.PrimaryScreen?.WorkingArea;
        if (area == null) return;

        var live = instances.Where(x => x.Process is { HasExited: false }).ToList();
        if (live.Count == 0) return;

        int gap = 4;
        int w = Math.Max(250, (area.Value.Width - gap * (cols + 1)) / cols);
        int h = Math.Max(180, (area.Value.Height - gap * (rows + 1)) / rows);

        for (int index = 0; index < live.Count; index++)
        {
            var hwnd = FindWindow(live[index].Process);
            if (hwnd == IntPtr.Zero) continue;
            int row = index / cols, col = index % cols;
            MoveWindow(hwnd, area.Value.Left + gap + col * (w + gap), area.Value.Top + gap + row * (h + gap), w, h, true);
        }
    }

    private void Arrange_Click(object sender, RoutedEventArgs e) => ArrangeWindows();
    private void Layout2_Click(object sender, RoutedEventArgs e) { RowsBox.Text = "2"; ColsBox.Text = "2"; ArrangeWindows(); }
    private void Layout3_Click(object sender, RoutedEventArgs e) { RowsBox.Text = "3"; ColsBox.Text = "3"; ArrangeWindows(); }
    private void Layout4_Click(object sender, RoutedEventArgs e) { RowsBox.Text = "4"; ColsBox.Text = "4"; ArrangeWindows(); }
    private void Layout50_Click(object sender, RoutedEventArgs e) { RowsBox.Text = "5"; ColsBox.Text = "10"; ArrangeWindows(); }

    private void InstanceCountBox_Changed(object sender, SelectionChangedEventArgs e)
    {
        if (!IsLoaded || InstanceCountBox.SelectedItem is not ComboBoxItem item) return;
        if (int.TryParse(item.Content?.ToString(), out int count)) BuildInstances(count);
    }

    private void RefreshStatuses()
    {
        var used = instances.Where(x => x.Process is { HasExited: false }).Select(x => x.Process!.Id).ToHashSet();
        var available = Process.GetProcessesByName("RobloxPlayerBeta").Where(p => !used.Contains(p.Id)).ToList();
        foreach (var item in instances.Where(x => x.Process == null || x.Process.HasExited))
        {
            var process = available.FirstOrDefault();
            if (process == null) break;
            item.Process = process;
            item.StartedAt = DateTime.Now - process.TotalProcessorTime;
            available.Remove(process);
        }

        int running = 0;
        foreach (var item in instances)
        {
            var card = InstancesPanel.Children[item.Id - 1] as Border;
            if (card?.Child is not Grid grid || grid.Children[0] is not StackPanel info) continue;
            var status = info.Children.OfType<TextBlock>().ElementAtOrDefault(1);
            var pid = info.Children.OfType<TextBlock>().ElementAtOrDefault(2);

            if (item.Process is { HasExited: false })
            {
                running++;
                status!.Text = "● Running";
                status.Foreground = Brushes.SpringGreen;
                pid!.Text = $"PID {item.Process.Id}  •  {(DateTime.Now - item.StartedAt):hh\:mm\:ss}";
            }
            else
            {
                status!.Text = "○ Offline";
                status.Foreground = Brushes.Gray;
                pid!.Text = "PID —";
            }
        }
        StatusText.Text = $"{running} running  •  {instances.Count} slots";
    }

    protected override void OnClosed(EventArgs e)
    {
        monitor.Stop();
        base.OnClosed(e);
    }
}

public sealed class RobloxInstance(int id) : IDisposable
{
    public int Id { get; } = id;
    public Process? Process { get; set; }
    public DateTime StartedAt { get; set; }

    public void Dispose()
    {
        try { Process?.Dispose(); } catch { }
    }
}
