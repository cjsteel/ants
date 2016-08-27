acemenu
=======

[![Build Status](https://travis-ci.org/cjsteel/ansible-role-acemenu.svg?branch=master)](https://travis-ci.org/cjsteel/ansible-role-acemenu)

An Ansible role that installs a very basic terminal based menu system.

Requirements
------------

* Ansible version 2.0.

    * Makes use of `blockinfile` extras module

Role Variables
--------------

Currently makes use of two 2 vars in defaults/main.yml

    acemenu_users :
      - bob

    acemenu_bin_dir: 'bin/acemenu'

Dependencies
------------

None at this time.

Playbook
--------

From the project directory you can copy and the acemenu.yml example playbook.

    cp roles/acemenu/files/acemenu.yml .

Example Playbook
----------------

    ---
    - hosts: acemenu
      become: false
      gather_facts: false
      roles:
        - acemenu

host_vars
---------

In host_vars for each target host, create and acemenu directory and a file called something like acemenu_users:

    mkdir -p host_vars/db/acemenu
    mkdir -p host_vars/web/acemenu

    cp roles/acemenu/files/host_vars/acemenu/acemenu_users host_vars/db/acemenu/.
    cp roles/acemenu/files/host_vars/acemenu/acemenu_users host_vars/web/acemenu/.

    nano host_vars/db/acemenu/acemenu_users
    nano host_vars/web/acemenu/acemenu_users

* Edit 

### host_vars example

    ---
    # file: host_vars/hostname/acemenu/acemenu_users
    
    # The `acemenu_users` variable includes the user_names on the target host that will have an installtion of acemenu.
    
    acemenu.yml:
          - user_one
          - user_two

Inventory example
-----------------

Edit your inventory file and add a group called [acemenu] and add the host information for each host on which you will be install acemenu.

    nano ../ace_test_vms/ansible/inventory/vagrant_ansible_inventory

### Example of vagrant generated inventory file

    # Generated by Vagrant
    [acemenu]
    web ansible_ssh_host=127.0.0.1 ansible_ssh_port=2222 ansible_ssh_private_key_file=/home/your_user_name/projects/ace_testing/ace_test_vms/.vagrant/machines/web/virtualbox/private_key ansible_ssh_user=deployment_user_name
    db ansible_ssh_host=127.0.0.1 ansible_ssh_port=2200 ansible_ssh_private_key_file=/home/your_user_name/projects/ace_testing/ace_test_vms/.vagrant/machines/db/virtualbox/private_key ansible_ssh_user=deployment_user_name
    
    [secondGroup]
    db

## testing_parc.yml

In your main playbook 

    ---
    - hosts: all
      become: false
      gather_facts: false
    
    - include: deployment_user.yml
      when: "'vagrant' in {{ ansible_ssh_user }}"
    
    - include: acemenu.yml

## Ansible command

Now run your ansible command






For testing with vagrant VM's


License
-------

MIT

Author Information
------------------

Christopher Steel
