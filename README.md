
acemenu
=======

[![Build Status](https://travis-ci.org/cjsteel/ansible-role-acemenu.svg?branch=master)](https://travis-ci.org/cjsteel/ansible-role-acemenu)

An Ansible role that installs a basic terminal based menu system. The role figures users home directories and works in LDAP environments as well.

The role sets up a sym link in `/etc/skel/bin/menu` pointing to `/etc/skel/bin/acemenu/menu.sh`

The role can be configured to targets users within a specific range of UID's. (not enabled)

**IMPORTANT** - an `echo` command in ~/.bashrc or ~/.bash_aliases on CentOS 7 prevents Ansilbe from connecting. Further investigation is required


Requirements
------------

* Ansible version 2.0.
    * Makes use of `blockinfile` extras module

### Installing Ansible Via miniconda

```shell
conda create --name ansible -c kbroughton ansible=2.0.0.2
source activate ansible
```

### Dependencies

* https://github.com/cjsteel/ansible-role-clone
* https://github.com/cjsteel/ansible-role-skel

Role Variables
--------------

Currently makes use of the following variables in defaults/main.yml.

At some point in time `acemenu_uid_min` and `acemenu_uid_max` are used to define the UID range of the users on remote systems that will have access to `acemenu`.

```yaml
---
# file: roles/acemenu/defaults/main.yml

acemenu_state             : 'present'
acemenu_install_type      : 'skel'
acemenu_install_type_user : False

acemenu_deployment_user : '{{ project_deployment_user }}'
#acemenu_uid_min     : 1001
#acemenu_uid_max     : 1001

acemenu_personal_bin: 'bin'
acemenu_bin_dir: '{{ acemenu_personal_bin }}/acemenu'
acemenu_help_dir: '{{ acemenu_bin_dir }}/helpfiles'

acemenu_user_homes:

#  acemenu_ansible_user:

#    home : '{{ fact_controller_home }}'
#    owner: '{{ acemenu_deployment_user }}'
#    group: '2001' # '100x'
#     mode : '0775'

#  auser_home:

#    home : '/home/users/auser'
#    owner: 'auser'
#    group: 'auser'
#    mode : '0775'
```

### group_vars

To create a group_vars entry do something like this depending on the desired results..

```shell
mkdir -p group_vars/acemenu
cp roles/acemenu/defaults/main.yml group_vars/acemenu/acemenu_defaults.yml
```

Edit as desired:

```shell
nano group_vars/acemenu/acemenu_defaults.yml
```

### as dependency

NEEDS MAJOR EDITING:

```shell
---
# file: roles/display/meta/main.yml

dependencies:

  - role: ensure_dirs
    tags: ['minc', 'ensure_dirs']
    ensure_dirs_on_remote: '{{ display_ensure_dirs_on_remote }}'
    ensure_dirs_on_local : '{{ display_ensure_dirs_on_local }}'

  - role: acemenu
    become: true
    tags: ['acemenu']
    skel_entries:

      - name: "meta/main.yml entry for /etc/skel/bin"
        path  : '/etc/skel/bin'
        user  : 'root'
        group : 'root'
        mode: '0755'
        state: 'directory' # options are 'directory' or 'absent'

      - name: 'template /etc/skel/bin/minc-toolkit-config.sh'
        src:  'minc-toolkit-config.sh'
        path: '/etc/skel/bin/minc-toolkit-config.sh'
        mode: '0755'
        state: 'template' # options are 'template' or 'absent'

      - name:  'template /etc/skel/bin/minc-toolkit-conf-{{ minc_ver}}.sh'
        src:   'versioned-minc-toolkit-config.sh'
        path:  '/etc/skel/bin/minc-toolkit-config-{{ minc_ver }}.sh'
        mode:  '0755'
        state: 'template' # options are 'template' or 'absent'
```

### host_vars

```shell
mkdir -p host_vars/workstation-001/acemenu
cp roles/acemenu/defaults/main.yml host_vars/workstation-001/acemenu/acemenu_custom.yml
nano host_vars/workstation-001/acemenu/acemenu_custom.yml
```

### user_vars
NOT IMPLEMENTED

```shell
mkdir -p user_vars/<username>/acemenu
cp roles/acemenu/defaults/main.yml user_vars/<username>/acemenu/defaults.yml
nano host_vars/host-01/acemenu/defaults.yml
```


Dependencies
------------

* skelNone at this time.

Inventory example
-----------------

### Testing

```shell
nano inventory_dev
```
```shell
[acemenu]
workstation-001
```

Playbooks
---------

### Role Playbook

Notice that the `gather_facts` variable is set to `true` so that we may determine the target hosts operating system and apply the appropriate template.

From the project directory you can copy and the acemenu.yml example playbook as follows:

```
cp roles/acemenu/files/acemenu.yml acemenu.yml
```

#### Content example:

```yaml
---
# file: project/acemenu.yml
- hosts: acemenu
  become: true
  gather_facts: true
  pre_tasks:

    - set_fact: fact_controller_user="{{ lookup('env','USER') }}"
    - debug: var=fact_controller_user

    - set_fact: fact_controller_home="{{ lookup('env','HOME') }}"
    - debug: var=fact_controller_home

  roles:
    - acemenu
```

### Main Playbook

In your main playbook, named `systems.yml` in this example, you want something like the following example:

#### systems.yml

```yaml
---
# file: project/systems.yml
- hosts: all
  become: false
  gather_facts: false

- include: deployment_user.yml

- include: shorewall.yml

- include: ldap.yml

- include: workstation.yml

- include: acemenu.yml
```

To copy this example from the role:

    cp roles/acemenu/files/systems.yml systems.yml
Ansible Command
---------------

    ansible-playbook systems.yml -i inventory/dev --limit workstation-001

### Problem

If rerunning the role results in the following error ensure that you have not added an `echo` command to the deployment users ~/.bashrc, ~/.bash_aliases, ~/.bash_profile or other file that is executed upon login:

    (_test) your_controller_user@automa:~/projects/ace_testing/ace_ansible$ ansible-playbook systems.yml -i inventory_dev

    PLAY [all] *********************************************************************

    PLAY [acemenu] *****************************************************************

    TASK [setup] *******************************************************************
    fatal: [web]: UNREACHABLE! => {"changed": false, "msg": "SSH Error: data could not be sent to the remote host. Make sure this host can be reached over ssh", "unreachable": true}
     [WARNING]: Could not create retry file 'testing_parc.retry'.         [Errno 2] No such file or directory: ''


    PLAY RECAP *********************************************************************
    web                        : ok=0    changed=0    unreachable=1    failed=0

## Testing

#### Start Vagrant

```shell
vagrant up --provision
```

### Connect to vm

```shell
vagrant ssh
```

#### Confirm changes to skel

```shell
sudo ls -al /etc/skel/bin
```

### add test user

```shell
sudo adduser --home /home/test_user -c "test user" test_user
```

### test

```shell
sudo su - test_user
source ~/.profile
menu
```

### remove user

If running multiple tests

```shell
sudo deluser --remove-home test_user
```

License
-------

MIT


Author Information
------------------

Christopher Steel
