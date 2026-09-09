# Prefs only, applied install-wide via policies.json — does not touch
# profiles.ini or create/select a profile, so the existing Sync-linked
# profile is left alone. Bookmarks/search engines/extensions are left to
# Firefox Sync rather than declared here, to avoid fighting it.
{
  programs.firefox = {
    enable = true;
    # Keep the legacy ~/.mozilla/firefox path (matches the existing profile);
    # avoids home-manager's newer XDG-path default for stateVersion >= 26.05.
    configPath = ".mozilla/firefox";

    policies = {
      DisablePocket = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;

      Preferences = {
        "browser.newtabpage.activity-stream.feeds.section.topstories" = {
          Value = false;
          Status = "default";
        };
        "browser.newtabpage.activity-stream.showSponsored" = {
          Value = false;
          Status = "default";
        };
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = {
          Value = false;
          Status = "default";
        };
        "browser.newtabpage.activity-stream.feeds.topsites" = {
          Value = false;
          Status = "default";
        };
      };
    };
  };
}
