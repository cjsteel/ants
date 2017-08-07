## To Do

## create playbook to add new menu items

* variable examples

```shell
acemenu_add_menu_item          : true              # must be passed to acemenu role
acemenu_menu_item_to_add       : display           # must be a single word.
acemenu_menu_item_content_file_source : 'files/bin/acemenu/help/{{ acemenu_menu_item_to_add }}.txt
```

* sort example:

```shell
sort input-file > output_file
```

​

## Other stuff



* Migrate config changes to skel role
* Find source of interference when an `echo` command is contained in .bashrc or .bash_alias
* Condense README.md
* Test using multiple users.
* sudo usage audit

## Completed

2016-08-06- convert  menu and menuitems.txt into templates
