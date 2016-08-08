acemenu
=======

[![Build Status](https://travis-ci.org/cjsteel/ansible-role-acemenu.svg?branch=master)](https://travis-ci.org/cjsteel/ansible-role-acemenu)

An Ansible role that installs a very basic terminal based menu system.

Requirements
------------

* Ansible version 2.0.

    * MAkes use of `blockinfile` extras module

Role Variables
--------------

Currently makes use of two 2 vars in defaults/main.yml

    acemenu_users :
      - bob

    acemenu_bin_dir: 'bin/acemenu'

Dependencies
------------

None at this time.

Example Playbook
----------------

    ---
    - hosts: acemenu
      become: false
      gather_facts: false
      roles:
        - ansible-role-acemenu

License
-------

MIT

Author Information
------------------

Christopher Steel
