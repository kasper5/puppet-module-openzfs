# puppet-module-openzfs

Install OpenZFS on RedHat/CentOS.

Apply this module and start using the puppet resource type `zpool` and zfs`.

e.g:

```
class myapp::filesystems {

  require openzfs
 
  zpool { 'myapp':
		pool => 'myapp',
		ensure => 'present',
		disk => 'sdb',
	}

	zfs { 'myapp/myapp':
		require => Zpool['myapp'],
		mountpoint => '/myapp',
		compression => 'on',
	}
}
```
