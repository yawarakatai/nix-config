{ ... }:

{
  xdg.configFile."zellij/config.kdl".text = ''
    keybinds {
        pane {
            bind "n" "Left" { MoveFocus "Left"; }
            bind "o" "Right" { MoveFocus "Right"; }
            bind "e" "Down" { MoveFocus "Down"; }
            bind "i" "Up" { MoveFocus "Up"; }
            bind "N" { NewPane; SwitchToMode "Normal"; }
            bind "E" { TogglePaneEmbedOrFloating; SwitchToMode "Normal"; }
            bind "I" { TogglePanePinned; SwitchToMode "Normal"; }
        }
        tab {
            bind "n" "Left" "Up" { GoToPreviousTab; SwitchToMode "Normal"; }
            bind "o" "Right" "Down" { GoToNextTab; SwitchToMode "Normal"; }
            bind "N" { NewTab; SwitchToMode "Normal"; }
        }
        resize {
            bind "n" "Left" { Resize "Increase Left"; }
            bind "o" "Right" { Resize "Increase Right"; }
            bind "e" "Down" { Resize "Increase Down"; }
            bind "i" "Up" { Resize "Increase Up"; }
            bind "N" { Resize "Decrease Left"; }
            bind "O" { Resize "Decrease Right"; }
            bind "E" { Resize "Decrease Down"; }
            bind "I" { Resize "Decrease Up"; }
        }
        move {
            bind "n" "Left" { MovePane "Left"; }
            bind "o" "Right" { MovePane "Right"; }
            bind "e" "Down" { MovePane "Down"; }
            bind "i" "Up" { MovePane "Up"; }
            bind "N" { MovePane; }
        }
    }
  '';
}
