{ ... }:
''
  // Work around WezTerm's initial configure bug
  window-rule {
      match app-id=r#"^org\.wezfurlong\.wezterm$"#
      default-column-width {}
  }

  // Open the Firefox picture-in-picture player as floating by default
  window-rule {
      match app-id=r#"firefox$"# title="^Picture-in-Picture$"
      open-floating true
  }

  // Global window styling
  window-rule {
      geometry-corner-radius 9
      clip-to-geometry true
      draw-border-with-background false
  }

  // Opacity rules for specific applications
  window-rule {
      match app-id=r#"^(kitty|thunar|org\.telegram\.desktop|discord|vesktop|org\.gnome\.Nautilus|nemo)$"#
      opacity 0.9
  }
''
