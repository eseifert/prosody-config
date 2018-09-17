pidfile = "/run/prosody/prosody.pid"

--
-- Network interfaces
--------------------------------

interfaces = { "127.0.0.1", "::1" }
http_interfaces = { "127.0.0.1", "::1" }

--
-- Datenbankanbindung
---------------------------------

default_storage = "sql"
storage = "sql"


--
-- POSTGRES SQL driver
---------------------------------
sql = {
    driver = "PostgreSQL";
    database = "prosody";
    host = "localhost";
    port = 5432;
    username = "prosody";
    password = "[passwd]";
}



--
-- Authentifizierung
---------------------------------

-- Passwörter gehashed abspeichern
authentication = "internal_hashed"

-- Admin-Account
admins = {"admin@trashserver.net"}


--
-- TLS Konfiguration
---------------------------------

c2s_require_encryption = true;
s2s_require_encryption = true;

s2s_secure_auth = true;
s2s_insecure_domains = {};

ssl = {
    dhparam = "/etc/mytls/dh4096.pem";
    key = "/etc/mytls/certmanager/privkey.pem";
    certificate = "/etc/mytls/certmanager/certs/trashserver.net/fullchain.pem";
    ciphers = "HIGH+kEDH:HIGH+kEECDH:HIGH:!PSK:!SRP:!3DES:!aNULL";
    options = { "no_sslv2", "no_sslv3", "no_tlsv1", "no_tlsv1_1", "no_ticket", "no_compression", "cipher_server_preference", "single_dh_use", "single_ecdh_use" };
}


--
-- LUA libevent nutzen für mehr als 1024 verbindungen
-- (Debian-Paket lua-event muss installiert sein)
-----------------------------------------------------

use_libevent = true



--
-- Prosody Module
---------------------------------

plugin_paths = { "/opt/prosody-modules", "/opt/prosody-modules-git" }

-- Aktivierte Module (global, für alle vHosts)
modules_enabled = {
		-- Wichtige Module
			"roster";
			"saslauth";
			"tls";
			"dialback";
		  	"disco";

		-- Empfohlene Module
			"private";
			"vcard";
			"offline";
			"admin_adhoc";
			"admin_telnet";
		        "http";

		-- Nice to have
			"legacyauth";
			"version";
		  	"uptime";
		  	"time";
		  	"ping";
			"register_web";
			"register";
			"posix";
			"bosh";
			"announce";
			"proxy65";
			"pep";
			"smacks";
			"smacks_offline";
			"carbons";
			"blocklist";
			"csi";
			"csi_battery_saver";
			"mam";
			"lastlog";
			"list_inactive";
			"cloud_notify";
			"compat_dialback";
			"throttle_presence";
			"log_auth";
			"omemo_all_access";
			"register_redirect";
			"http_upload_external";
			"server_contact_info";
			"websocket";
};


---
--- Low slow events module
log_slow_events_threshold = 2



--
-- Logging (muss hier in Global section stehen!)
----------------------------------

-- log = "/var/log/prosody/prosody.log"
log = {
    --debug = "/var/log/prosody/debug.log";
    -- info = "/var/log/prosody/info.log";
    -- warn = "/var/log/prosody/warn.log";
    error = "/var/log/prosody/error.log";
}



--
-- Statistiken
------------------------------------

statistics = "statsd"
statistics_interval = 30

statistics_config = {
    statsd_server = "10.8.1.1";
    statsd_port = 9125;
}



--
-- Netzwerkkonfiguration
---------------------------------

network_settings = {
    tcp_backlog = 64;
}


--
-- Legacy SSL für Verbindungen auf 443
-- (443 wird auf 5223 weitergeleitet)
---------------------------------

legacy_ssl_interfaces = { "127.0.0.1", "::1" }
legacy_ssl_ports = { 5223 }



--
-- Register Web Template files
----------------------------------

register_web_template = "/etc/prosody/register-template";


--
-- MAM settings
----------------------------

default_archive_policy = true;
archive_expires_after = "4w";


--
-- HTTP Upload settings
----------------------------

-- 50 MB
http_max_content_size = 52428800;
http_upload_file_size_limit = 52428800;
http_upload_path = "/var/lib/prosody/uploads";


--
-- HTTP upload external settings
----------------------------

http_upload_external_base_url = "https://uploads.trashserver.net/upload/"
http_upload_external_secret = "[secret]"
http_upload_external_file_size_limit = 50000000 -- bytes




--
-- HTTP Config
----------------------------------

http_default_host = "xmpp.trashserver.net"

http_paths = {
    register_web = "/register";
}

-- Websocket 
consider_websocket_secure = true;


--
-- Bosh config
----------------------------------

cross_domain_bosh = true;
consider_bosh_secure = true;


--
-- Register redirect
----------------------------------

no_registration_whitelist = true
registration_url = "https://trashserver.net/registrieren/"
registration_text = "Registriere dich bitte auf der trashserver.net Homepage."



--
-- SMACK settings 
-- (also for relevant for push)
----------------------------------

smacks_enabled_s2s = true
smacks_hibernation_time = 3600 
smacks_max_unacked_stanzas = 10
smacks_max_ack_delay = 60
smacks_max_hibernated_sessions = 10
smacks_max_old_sessions = 10


--
-- Push fix for ChatSecure
push_notification_important_body = "New Message"


--
-- Service Discovery
----------------------------------

disco_items = {
    { "conference.trashserver.net", "The trashserver.net MUC" };
}



----
--- Contact info
---------------------------------
contact_info = {
  abuse 	= { "mailto:xmpp@trashserver.net", "xmpp:admin@trashserver.net" };
  admin 	= { "mailto:xmpp@trashserver.net", "xmpp:admin@trashserver.net" };
  feedback 	= { "mailto:xmpp@trashserver.net", "xmpp:admin@trashserver.net" };
  sales 	= { "mailto:xmpp@trashserver.net", "xmpp:admin@trashserver.net" };
  security 	= { "mailto:xmpp@trashserver.net", "xmpp:admin@trashserver.net" };
  support 	= { "mailto:xmpp@trashserver.net", "xmpp:admin@trashserver.net" };
};


--
-- XMPP VirtualHosts
------------------------------------

VirtualHost "trashserver.net"
    -- disable in-band registrations
    allow_registration = false
    min_seconds_between_registrations = 60

    http_host = "xmpp.trashserver.net"

    Component "conference.trashserver.net" "muc"
    	name = "trashserver.net Chatrooms"
    	restrict_room_creation = false
        max_history_messages = 500
		modules_enabled = {
			"mam_muc",
			"vcard_muc",
		}
		muc_log_by_default = true

    Component "pubsub.trashserver.net" "pubsub"
