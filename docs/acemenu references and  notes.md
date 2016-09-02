# ansible.role.acemenu recipe.md

## References

### Untested

*[](http://stackoverflow.com/questions/33343215/how-to-get-remote-users-home-directory-in-ansible)

#### Ansible getent Example

Create a simple playbook named: playbooks/ad-hoc/get-user-homedir.yml

- hosts: all
  tasks:
    - name:
      shell: >
        getent passwd {{ user }} | cut -d: -f6
      changed_when: false
      register: user_home

    - name: debug output
      debug: var=user_home.stdout

#### You can use expanduser.
(this probably does not work)

For instance, while looping over a user list:

- name: Deploys .bashrc
  template:
    src: bashrc.j2
    dest: "{{ '~' + item | expanduser }}/.bashrc"
    mode: 0640
    owner: "{{ item }}"
    group: "{{ item }}"
  with_items: user_list



### 
* [](http://stackoverflow.com/questions/35605603/using-ansible-set-fact-to-create-a-dictionary-from-register-results)

## Notes

* We need to ensure that this is done as a regular user on the remote system.
* We may need to be sure that the users home directory is mounted via LDAP.

## Variables

acemenu_users: []
acemenu_root_dir: '$HOME/bin/scripts/'

## Gather all users on system

    awk -F':' '{ print $1}' /etc/passwd
    
    getent passwd ansible | cut -d: -f1

## Intersecting script?

#!/bin/bash

for i in {000..999}; do 
    getent passwd "e${i}" 2> test.txt
done

## get minimum UID on a system

    grep UID_MIN /etc/login.defs

### output example

    UID_MIN			 1000
    #SYS_UID_MIN		  100

## References

* http://www.cyberciti.biz/faq/linux-list-users-command/
* http://unix.stackexchange.com/questions/128256/how-can-i-download-all-usernames

## get UID limit ##
l=$(grep "^UID_MIN" /etc/login.defs)
## use awk to print if UID >= $UID_LIMIT ##
awk -F':' -v "limit=${l##UID_MIN}" '{ if ( $3 >= limit ) print $1}' /etc/passwd

### output example

## find a way to create list of "regular" users, system accounts and so on.

( untested )

#!/bin/bash
# Name: listusers.bash
# Purpose: List all normal user and system accounts in the system. Tested on RHEL / Debian Linux
# Author: Vivek Gite <www.cyberciti.biz>, under GPL v2.0+
# -----------------------------------------------------------------------------------
_l="/etc/login.defs"
_p="/etc/passwd"
 
## get mini UID limit ##
l=$(grep "^UID_MIN" $_l)
 
## get max UID limit ##
l1=$(grep "^UID_MAX" $_l)
 
## use awk to print if UID >= $MIN and UID <= $MAX and shell is not /sbin/nologin   ##
echo "----------[ Normal User Accounts ]---------------"
awk -F':' -v "min=${l##UID_MIN}" -v "max=${l1##UID_MAX}" '{ if ( $3 >= min && $3 <= max  && $7 != "/sbin/nologin" ) print $0 }' "$_p"
 
 
echo ""
echo "----------[ System User Accounts ]---------------"
awk -F':' -v "min=${l##UID_MIN}" -v "max=${l1##UID_MAX}" '{ if ( !($3 >= min && $3 <= max  && $7 != "/sbin/nologin")) print $0 }' "$_p"

### Become target user(s)

### How to get a users home directory in all version sof Ansible

# * works for ldap as well

# https://github.com/ansible/ansible/issues/11902
# http://stackoverflow.com/questions/33343215/how-to-get-remote-users-home-directory-in-ansible

- hosts: all
  tasks:
    - name:
      shell: >
        getent passwd {{ user }} | cut -d: -f6
      changed_when: false
      register: user_home

    - name: debug output
      debug: var=user_home.stdout

### Ensure for users_bash_scripts_dir

    ~/bin/scripts

- name: ensure for remote directories
  file:
    state   : '{{ item.value.state   | default("directory") }}'
    path    : '{{ item.value.path    | default(mandatory) }}'
    owner   : '{{ item.value.owner   | default(omit) }}'
    group   : '{{ item.value.group   | default(omit) }}'
    mode    : '{{ item.value.mode    | default(omit) }}'
    recurse : '{{ item.value.recurse | default(omit) }}'
  with_dict: acemenu_users_root_dirs

### Ensure for path to acemenu.sh

#### ensure for our path block in the users ~/.bashrc

# see following
#
# http://stackoverflow.com/questions/33343215/how-to-get-remote-users-home-directory-in-ansible
# http://stackoverflow.com/questions/21344777/how-to-switch-a-user-per-task-or-set-of-tasks

# * [ User-friendly command to list all users on Ubuntu system? ]( http://unix.stackexchange.com/questions/63509/user-friendly-command-to-list-all-users-on-ubuntu-system )

# Get list of users with passwords

# sudo grep -vE '^[^*!]+:[*!]:' /etc/shadow | sort | cut -d: -f1
# Breakdown
# Only show users which have a password set:
#
#    sudo grep -vE '^[^*!]+:[*!]:' /etc/shadow
#
# Sort by username:
#
#    sort 
# * [ Linux user list & UID / bash layer ](http://stackoverflow.com/questions/20269008/linux-user-list-uid-bash-layer)
# *[]() 
# list only usernames
#
#    awk -F':' '{ print $1}' /etc/passwd
#
# Discard all information except for the username:
#
#    cut -d: -f1
#
# http://www.cyberciti.biz/faq/linux-list-users-command/
#
#
#  grep "^UID_MIN" /etc/login.defs
#  grep UID_MIN /etc/login.defs
# awk -F':' -v "min=1000" -v "max=60000" '{ if ( $3 >= min && $3 <= max ) print $0}' /etc/passwd | cut -d: -f1

- name: "get remote systems users by UID range"
  shell: >
    awk -F':' -v "min=500" -v "max=60000" '{ if ( $3 >= min && $3 <= max ) print $0}' /etc/passwd | cut -d: -f1
  changed_when: false
  register: users_by_range
