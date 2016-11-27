## selenium [![Build Status](https://travis-ci.org/MassiveHiggsField/ansible-role-selenium.svg?branch=master)](https://travis-ci.org/MassiveHiggsField/ansible-role-selenium)

Sets up a selenium server running via xvfb and optionally installs firefox and chrome. Everything will be setup pretty automatically, because there are some version restrictions to which 
selenium server versions runs best on which jdk and operating system. Selenium server since version 3 requires jdk 8 and the geckodriver for running firefox. The geckodriver only fully supports
firefox versions 48 and above. All rhel based distributions (like centos) only run firefox 45.x and jdk 7, but can't be easily upgraded (depdencies with gtk3 etc...). Following setups are 
supported right now:

|                             | Firefox                 | Chrome | Selenium | JDK  |
| --------------------------- | ----------------------- | ------ | -------- | ---- |
| Ubuntu 12.04, 14.04, 16.04  | latest via apt          |        | 3.x      | 8    |
| Debian 8                    | latest via mozilla repo |        | 3.x      | 8    |
| Centos 6/7                  | 45.x via official repo  |        | 2.53.1   | 7    | 

If additional setups are needed, open an issue. 

#### Requirements

None

#### Variables

* `selenium_server_version`:       [default: `3.0.1`] Selenium server version
* `selenium_server_dir`:           [default: `/opt/selenium`] Base dir where all binaries are installed
* `selenium_server_log`:           [default: `/opt/selenium/selenium.log`] Selenium server log file
* `selenium_server_download`:      [default: `http://selenium-release.storage.googleapis.com/{{ selenium_server_version | regex_replace('\\.[0-9]+$', '') }}/selenium-server-standalone-{{ selenium_server_version }}.jar`] Download url for selenium server
* `selenium_geckodriver_version`:  [default: `0.11.1`] Geckodriver version to install
* `selenium_geckodriver_download`: [default: `https://github.com/mozilla/geckodriver/releases/download/v{{ selenium_geckodriver_version }}/geckodriver-v{{ selenium_geckodriver_version }}-linux64.tar.gz`] Download url for gecko driver

## Dependencies

* `geerlingguy.java`

#### Example

```yaml
---
- hosts: all
  roles:
  - role: selenium
    selenium_server_log: /vagrant/build/logs/
```

#### Start/Stop/Restart Selenium

via systemd:

```
$ service selenium start
$ service selenium stop
$ service selenium restart
```

via initv

```
$ /etc/init.d/selenium start
$ /etc/init.d/selenium stop
$ /etc/init.d/selenium restart
```

#### License and Author

Author:: Alex Knoll (arknoll@gmail.com)

Copyright:: 2015, Alex Knoll

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

#### Contributing

We welcome contributed improvements and bug fixes via the usual workflow:

1. Fork this repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request

Additionally there is a test script located in the root of this directory with which you can test individual distros like so (docker must be installed)

    ~# sudo ./test.sh -p -r -d ubuntu1604
    
See "./test.sh" for more information.