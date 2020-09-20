class openzfs::install {

	case $osfamily {

		/RedHat/: {

			$osminor = $facts['os']['release']['minor']
			$osmajor = $facts['os']['release']['major']
			$split = "_"
		
			file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux':
				ensure => 'file',
				owner => 'root',
				group => 'root',
				mode => '0644',
				source => 'puppet:///modules/openzfs/RPM-GPG-KEY-zfsonlinux',
			}

			package { "zfs-release":
				ensure => 'installed',
				source => "http://download.zfsonlinux.org/epel/zfs-release.el$osmajor$split$osminor.noarch.rpm",
			}

			file { '/etc/yum.repos.d/zfs.repo':
				ensure  => file,
				mode    => '0640',
				owner   => 'root',
				group   => 'root',
				content  => template("openzfs/zfs.repo.erb"),
			}

			package { 'zfs':
				require => File['/etc/yum.repos.d/zfs.repo'],
				ensure => 'installed',
			}

			exec { 'modprobe-zfs':
				require => Package['zfs'],
				path => [ '/usr/bin', '/bin', '/sbin', '/usr/sbin' ],
				command => '/sbin/modprobe zfs',
				unless => "/sbin/lsmod | grep -o zfs",
			}

			file { '/etc/modules-load.d/zfs.conf':
				ensure => 'file',
				owner => 'root',
				group => 'root',
				mode => '0644',
				content => 'zfs',
			}
		}
	}
}
