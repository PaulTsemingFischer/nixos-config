# Self-hosted Seafile (file sync/share), reachable only over Tailscale.
#
# Deployment follows the official Seafile 13.0 Docker Compose layout
# (https://manual.seafile.com/13.0/repo/docker/ce/) -- mariadb + redis +
# seafileltd/seafile-mc -- but skips the bundled Caddy container (that's
# there to get a public domain + Let's Encrypt cert; we don't need either
# since this never leaves the tailnet) and is translated to
# virtualisation.oci-containers instead of docker-compose so it's managed
# declaratively like the rest of this config.
#
# ONE-TIME SETUP after the first `sudo nixos-rebuild switch` with this file:
#
#   1. sudo tailscale up
#      This machine is currently logged out of Tailscale (see `tailscale
#      status`), so it has no tailnet IP yet.
#
#   2. Get this machine's tailnet IP: `tailscale ip -4`
#      Put that IP (or, if you use MagicDNS, this device's
#      "<name>.<tailnet>.ts.net" hostname) into SEAFILE_SERVER_HOSTNAME
#      below, then `sudo nixos-rebuild switch` again. Seafile bakes this
#      hostname into generated links/config on first boot, so it needs to
#      be right *before* the containers start for the first time.
#
#   3. Create /etc/seafile/seafile.env (root:root, mode 600) -- this file
#      holds real secrets and must NOT be committed to git; it lives only
#      on this machine. Generate each value with `head -c 32 /dev/urandom
#      | base64`, except the two *_ROOT_PASSWORD keys, which must be set to
#      the SAME value as each other (MYSQL_ROOT_PASSWORD is what the
#      mariadb container reads to set its own root password;
#      INIT_SEAFILE_MYSQL_ROOT_PASSWORD is what Seafile's first-boot init
#      script reads to use that same root account to create the seafile
#      user/databases). Contents:
#
#        SEAFILE_MYSQL_DB_PASSWORD=<random>
#        MYSQL_ROOT_PASSWORD=<random, same as the next line>
#        INIT_SEAFILE_MYSQL_ROOT_PASSWORD=<same as the line above>
#        JWT_PRIVATE_KEY=<random, 32+ chars>
#        REDIS_PASSWORD=<random>
#        INIT_SEAFILE_ADMIN_EMAIL=<your email>
#        INIT_SEAFILE_ADMIN_PASSWORD=<a password -- only used once, to
#          create the account on first boot; change it via the web UI
#          afterward rather than editing this file, since nothing re-reads
#          it after that first run>
#
#      SEAFILE_MYSQL_DB_PASSWORD, MYSQL_ROOT_PASSWORD and
#      INIT_SEAFILE_MYSQL_ROOT_PASSWORD only matter on first boot too --
#      mariadb bakes them into its own data directory
#      (/var/lib/seafile-data/mysql) right away and never reads this file
#      for them again. That means losing this file doesn't delete any
#      data (that all lives under /var/lib/seafile-data), but regenerating
#      it with fresh random values and recreating the containers WOULD
#      lock the seafile container out of its own still-intact database --
#      the new password wouldn't match what mariadb already has on disk.
#      Back this file up somewhere durable (e.g. a password manager) once
#      it's filled in.
#
#   4. sudo nixos-rebuild switch, then browse to
#      http://<tailscale-hostname-or-ip> and log in with the admin
#      email/password you put in seafile.env.
#
# Note: mariadb takes 10-30s to finish initializing on first boot. The
# seafile container's entrypoint retries the DB connection on its own, so
# this resolves itself without help -- oci-containers' dependsOn only
# orders systemd unit start, it doesn't wait for a health check the way
# docker-compose's `condition: service_healthy` does.
{ pkgs, ... }:
{
  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers = {
    seafile-db = {
      image = "mariadb:10.11";
      environmentFiles = [ "/etc/seafile/seafile.env" ];
      environment = {
        MYSQL_LOG_CONSOLE = "true";
        MARIADB_AUTO_UPGRADE = "1";
      };
      volumes = [ "/var/lib/seafile-data/mysql:/var/lib/mysql" ];
      extraOptions = [ "--network=seafile-net" ];
    };

    seafile-redis = {
      image = "redis";
      environmentFiles = [ "/etc/seafile/seafile.env" ];
      cmd = [
        "/bin/sh"
        "-c"
        ''exec redis-server --requirepass "$REDIS_PASSWORD" --save "" --appendonly no''
      ];
      extraOptions = [ "--network=seafile-net" ];
    };

    seafile = {
      image = "seafileltd/seafile-mc:13.0-latest";
      environmentFiles = [ "/etc/seafile/seafile.env" ];
      environment = {
        SEAFILE_MYSQL_DB_HOST = "seafile-db";
        SEAFILE_MYSQL_DB_PORT = "3306";
        SEAFILE_MYSQL_DB_USER = "seafile";
        SEAFILE_MYSQL_DB_CCNET_DB_NAME = "ccnet_db";
        SEAFILE_MYSQL_DB_SEAFILE_DB_NAME = "seafile_db";
        SEAFILE_MYSQL_DB_SEAHUB_DB_NAME = "seahub_db";
        TIME_ZONE = "America/New_York";
        SEAFILE_SERVER_PROTOCOL = "http";
        # This machine's stable tailnet IP (`tailscale ip -4`).
        SEAFILE_SERVER_HOSTNAME = "100.76.151.9";
        SITE_ROOT = "/";
        NON_ROOT = "false";
        SEAFILE_LOG_TO_STDOUT = "false";
        ENABLE_GO_FILESERVER = "true";
        # SeaDoc's own server container isn't deployed here -- leave it off
        # rather than advertise a feature with nothing behind it.
        ENABLE_SEADOC = "false";
        CACHE_PROVIDER = "redis";
        REDIS_HOST = "seafile-redis";
        REDIS_PORT = "6379";
        ENABLE_NOTIFICATION_SERVER = "false";
        ENABLE_SEAFILE_AI = "false";
        ENABLE_FACE_RECOGNITION = "false";
        MD_FILE_COUNT_LIMIT = "100000";
      };
      volumes = [ "/var/lib/seafile-data/seafile:/shared" ];
      ports = [ "80:80" ];
      dependsOn = [
        "seafile-db"
        "seafile-redis"
      ];
      extraOptions = [ "--network=seafile-net" ];
    };
  };

  # oci-containers doesn't manage custom docker networks itself, so create
  # the one all three containers share (see extraOptions above) before any
  # of them start.
  systemd.services.docker-network-seafile-net = {
    description = "Create the seafile-net docker network";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker network inspect seafile-net >/dev/null 2>&1 || docker network create seafile-net
    '';
  };

  systemd.services."docker-seafile-db".after = [ "docker-network-seafile-net.service" ];
  systemd.services."docker-seafile-db".requires = [ "docker-network-seafile-net.service" ];
  systemd.services."docker-seafile-redis".after = [ "docker-network-seafile-net.service" ];
  systemd.services."docker-seafile-redis".requires = [ "docker-network-seafile-net.service" ];
  systemd.services."docker-seafile".after = [ "docker-network-seafile-net.service" ];
  systemd.services."docker-seafile".requires = [ "docker-network-seafile-net.service" ];

  systemd.tmpfiles.rules = [
    "d /var/lib/seafile-data 0750 root root -"
    "d /var/lib/seafile-data/mysql 0750 root root -"
    "d /var/lib/seafile-data/seafile 0750 root root -"
  ];

  # Docker publishes container ports via DNAT in the nat table, which is
  # resolved before networking.firewall's INPUT-chain rules ever see the
  # packet -- so networking.firewall.interfaces."tailscale0".allowedTCPPorts
  # would silently NOT restrict this; the port would stay reachable from the
  # LAN (and the internet, if the router forwards it) regardless of what the
  # nixos firewall says. Docker provides the DOCKER-USER chain specifically
  # for host-level rules that must run before its own, so scope port 80 to
  # the tailscale0 interface there instead. Rules are deleted then
  # reinserted on every start so this stays correct (no duplicates, no stale
  # rules) across docker.service restarts.
  systemd.services.docker-seafile-firewall = {
    description = "Restrict Seafile's published port to the Tailscale interface";
    after = [
      "docker.service"
      "tailscale.service"
      "docker-seafile.service"
    ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.iptables ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      iptables -D DOCKER-USER -i tailscale0 -p tcp --dport 80 -j ACCEPT 2>/dev/null || true
      iptables -D DOCKER-USER -p tcp --dport 80 -j DROP 2>/dev/null || true
      iptables -I DOCKER-USER 1 -p tcp --dport 80 -j DROP
      iptables -I DOCKER-USER 1 -i tailscale0 -p tcp --dport 80 -j ACCEPT
    '';
  };
}
