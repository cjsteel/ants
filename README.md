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

    ---
    # defaults file for ansible-role-acemenu
    
    acemenu_uid_min: 1000
    acemenu_uid_max: 60000 
    acemenu_bin_dir: 'bin/acemenu'

### group_vars

To create a group_vars entry do something like this depending on the desired results..

    mkdir -p group_vars/acemenu
    cp roles/acemenu/defaults/main.yml group_vars/acemenu/defaults.yml

Edit as desired:

    nano group_vars/acemenu/defaults.yml

### host_vars

    mkdir -p host_vars/host-01/acemenu
    cp roles/acemenu/defaults/main.yml host_vars/host-01/acemenu/defaults.yml
    nano host_vars/host-01/acemenu/defaults.yml

### user_vars
NOT IMPLEMENTED

    mkdir -p user_vars/<username>/acemenu
    cp roles/acemenu/defaults/main.yml user_vars/<username>/acemenu/defaults.yml
    nano host_vars/host-01/acemenu/defaults.yml


Dependencies
------------

None at this time.

Inventory example
-----------------

### Testing

    nano inventory_dev

### Example of vagrant generated inventory file

    [acemenu]
    web ansible_ssh_host=127.0.0.1 ansible_ssh_port=2222 ansible_ssh_user=your_deployment_user
    #db ansible_ssh_host=127.0.0.1 ansible_ssh_port=2200 ansible_ssh_user=your_deployment_user

Playbooks
---------

### Main Playbook

In your main playbook, named `systems.yml` in this example, you want something like the following example:

#### systems.yml

    ---
    - hosts: all
      become: false
      gather_facts: false
    
    - include: acemenu.yml

To copy this example from the role:

    cp roles/acemenu/files/systems.yml systems.yml

### Role Playbook

From the project directory you can copy and the acemenu.yml example playbook.

    cp roles/acemenu/files/acemenu.yml acemenu.yml

#### acemenu.yml example

Notice that the `gather_facts` variable is set to `true` so that we may determine the target hosts operating system and apply the appropriate template.

    ---
    - hosts: acemenu
      become: true
      gather_facts: true
      roles:
        - acemenu

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
create_project test
create_project test
