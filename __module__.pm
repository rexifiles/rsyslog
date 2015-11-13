package Rex::Rsyslog;
use Rex -base;
use Rex::Ext::ParamLookup;

desc 'Install rsyslog onto a remote client';
task 'setup', sub { 

	# :msg,contains,"[R1] CRIT" @$rsyslogserver:514
	pkg "rsyslog",
		ensure => "latest",
		on_change => sub {
			say "rsyslog installed";
		};

        file "/etc/rsyslog.d/${logname}.conf",
                content => template("files/etc/rsyslog.d/rsyslog.tmpl", conf => { ip_address => "$ip_address", namespace => "$logname" }),
                on_change => sub {
                }
	};

	service rsyslog => ensure => "started";
};

desc 'add the config to rsyslog server';
task 'configadd', set_server(rsyslog1.net.xarlos.me), sub {

	my $ip_address = param_lookup "ip";
	my $logname    = param_lookup "logname";

	file "/etc/rsyslog.d/${logname}.conf", 
		content => template("files/etc/rsyslog.d/rsyslog.tmpl", conf => { ip_address => "$ip_address", namespace => "$logname" }),
		on_change => sub {
			say "config added";
		}
	};
};

1;
