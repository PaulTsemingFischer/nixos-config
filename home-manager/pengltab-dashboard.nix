# Serves the pengltab dashboard (~/Projects/pengltab/dashboard-app)
# as a static site on localhost, so every browser new tab points at the
# same running server instead of each one spinning up its own. Rebuild the
# site with `npm run build` inside dashboard-app/ after making changes --
# this service only serves whatever is currently in dist/.
{ pkgs, ... }:
{
  systemd.user.services.pengltab-dashboard = {
    Unit = {
      Description = "Static server for the pengltab new-tab dashboard";
    };
    Service = {
      ExecStart = "${pkgs.python3}/bin/python3 %h/Projects/pengltab/dashboard-app/serve.py %h/Projects/pengltab/dashboard-app/dist 4173";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
