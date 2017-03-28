
acemenu
=======

[![Build Status](https://travis-ci.org/cjsteel/ansible-role-acemenu.svg?branch=master)](https://travis-ci.org/cjsteel/ansible-role-acemenu)

An Ansible role that installs a basic terminal based menu system. The role figures users home directories and works in LDAP environments as well.

The role can be configured to targets users within a specific range of UID's.

**IMPORTANT** - an `echo` command in ~/.bashrc or ~/.bash_aliases on CentOS 7 prevents Ansilbe from connecting. Further investigation is required


Requirements
------------

* Ansible version 2.0.

    * Makes use of `blockinfile` extras module

### Installing

#### Via miniconda

    conda create --name ansible -c kbroughton ansible=2.0.0.2
    source activate ansible


Role Variables
--------------

Currently makes use of the following three variables in defaults/main.yml. `acemenu_uid_min` and `acemenu_uid_max` are used to define the UID range of the users on remote systems that will have access to `acemenu`.

```yaml
---
# file: roles/acemenu/defaults/main.yml

acemenu_state       : 'present'

acemenu_remote_user : '{{ fact_controller_user }}'
acemenu_uid_min     : 1001
acemenu_uid_max     : 1001

acemenu_personal_bin: 'bin'
acemenu_bin_dir: '{{ acemenu_personal_bin }}/acemenu'
acemenu_help_dir: '{{ acemenu_bin_dir }}/helpfiles'

acemenu_user_homes:

  acemenu_ansible_user:

    home : '/home/{{ acemenu_remote_user }}'
    owner: '{{ acemenu_remote_user }}'
    group: '2001' # '100x'
    mode : '2001' # '100x'

#  acemenu_admin_user:
#
#    home : '/home/admin'
#    owner: 'admin' # '100x'
#    group: 'admin' # '100x'
#    mode : '0755'
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

None at this time.

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

    ansible-playbook systems.yml -i inventory/development

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


License
-------

MIT


Author Information
------------------

Christopher Steel
