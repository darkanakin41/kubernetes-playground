local ddb = import 'ddb.docker.libjsonnet';

local domain = std.join('.', [std.extVar("core.domain.sub"), std.extVar("core.domain.ext")]);
local environment = std.extVar("core.env.current");
local port_prefix = std.extVar("docker.port_prefix");

local web_workdir = "/var/www/html";
local app_workdir = "/app";

local prefix_port(port, output_port = null)= [port_prefix + (if output_port == null then std.substr(port, std.length(port) - 2, 2) else output_port) + ":" + port];

ddb.Compose() {
	"services": {
		"nginx": ddb.Build("nginx")
		    + {
		        [if ddb.env.is('k8s') then "ports"]: ["8000:80"],
		        depends_on: ['php-fpm'],
		        environment: {
		            SERVERNAME: 'domain',
		            DOCUMENTROOT: web_workdir + '/web',
		            ENVIRONMENT: environment,
		        },
                volumes: [
                    ddb.path.project + "/app:" + web_workdir + ":cached"
                ]
            },
		"database": ddb.Image("mariadb:10.4.13")
		    + {
		        environment: {
		            MYSQL_ROOT_PASSWORD: 'mysqlroot',
                    MYSQL_DATABASE: 'gfi',
                    MYSQL_USER: 'mysqlusr',
                    MYSQL_PASSWORD: 'gfi',
		        }
            },
		"php-fpm": ddb.Build("php")
            + (if ddb.env.is("dev") then ddb.User() else {})
            + (if ddb.env.is("dev") then ddb.XDebug() else {})
		    + {
		        depends_on: ['redis'],
		        links: ['database:mysql'],
		        environment: {
		            DRUSH_VERSION: 9,
                    XDEBUG: 0,
		        },
                volumes: [
                    ddb.path.project + "/app:" + web_workdir + ":cached"
                ]
            },
		"redis": ddb.Build("redis"),
//		"solr": ddb.Build("solr:7.3-slim")
//		    + {
//                volumes: [
//                    ddb.path.project + "/.k8s/solr/config/solr/:/opt/solr/server/solr/collection1/conf:rw"
//                ]
//            },
		"varnish": ddb.Build("varnish")
            + (if ddb.env.is('dev') then ddb.VirtualHost("80", domain, "www") else {})
		    + {
		        links: ['nginx:web-backed'],
		        [if ddb.env.is('k8s') then "ports"]: ["80:80"],
            },
	}
}
