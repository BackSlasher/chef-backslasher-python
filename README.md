# backslasher-python-cookbook

A cookbook for managing python-related resources in a simple way  
This is mostly a ripoff of the [python cookbook](https://github.com/poise/python), since it's both deprecated and has its resource names stolen by [poise-python cookbook](https://github.com/poise/poise-python)  
Resources:

* `backslasher_python_pip_installer`: Makes sure a python envrionment has pip installed
* `backslasher_python_pip`: A pip package
* `backslasher_python_virtualenv`: A virtual environment

## Supported Platforms

Should work on normal Linux boxes. Possibly on Windows.  
I'm testing on:

* Ubuntu 14.04
* CentOS 6 (6.7)
* CentOS 7 (7.1)

## Attributes

* `['backslasher-python']['install_method']`: How to install python. Defaults to `package`. I'm currently not supoorting any other method.

## Recipes

### backslasher-python::default
The works - installs Python, pip and virtualenv.  
Python is installed according to `['backslasher-python']['install_method']`  

### backslasher-python::package
Installs python using the repo's packages.  
Provides both python runtime and Python development headers

### backslasher-python::pip
Installs pip on the "regular" Python (the one available as `python`)

### backslasher-python::virtualenv
Installs the virtualenv pip package on the "regular" Python. Also makes sure pip is installed.

## Resources

### backslasher\_python\_pip\_installer
Installs pip on a specific python executable

#### Properties
* `python_path`: Python binary to install pip on.  
    Defaults to `python`, which should find the "system" python

**Note**: This action might overwrite the "primary" pip binary. There is no easy way to avoid this since there is no way to instruct `setuptools` not to create "entry points". I'll happily accept a PR for fixing this.

### backslasher\_python\_pip
Installs/removed/upgrades a pip package

### Actions
* `install`: Install the pip package
* `upgrade`: Upgrade the pip package if it is uninstalled / has version mismatch. Will upgrade to latest by default.
* `remove`: Remove the pip package if installed

#### Properties
* `python_path`: Python binary to install on.  
    Not relevant if using `virtualenv` property.  
    Defaults to `python`, which should find the "system" python.
* `package_name`: Pip package to install. Defaults to the resource's name
* ``package_url`: Optional. Used to specify a URL to install the package from (e.g. `pip install git+git://git.myproject.org/MyProject#egg=MyProject`)
* `version`: Optional. Specifies a pip version to install
* `virtualenv`: Optional. Specifies a virtualenv path to install/remove the pip package in
* `timeout`: Time allotted for pip commands. Defaults to 900 seconds (15 min)
* ``user`: User to run the commands under
* `group`: Group to run the commands under
* `environment`: Hash of environment variables to pass to the pip commands
* `install_options`: An array of arguments to pass to the pip commands when installing / upgrading packages

### backslasher\_virtualenv
Manages a python virtualenv

### Actions
* `create`: Creates the virtualenv
* `delete`: Deletes the virtualenv

#### Properties
* `path`: Location inside the filesystem of the virtualenv. Defaults to the resource's name
* `interpreter`: Optional. Python binary used for venv. Defaults to the system python
* `owner`: Optional. Owning user of the virtualenv
* `group`: Optional. Owning group of the virtualenv
* `options`: Optional. A string of arguments to pass the virtualenv creator

## License and Authors
Licensed [GPL v2](http://choosealicense.com/licenses/gpl-2.0/)  
Author: [Nitzan Raz](https://github.com/BackSlasher) ([backslasher](http://backslasher.net))

I'll be happy to accept contributions or to hear from you!
