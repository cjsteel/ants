## cat ~/.bashrc

# ~/.bash_aliases, instead of adding them here directly.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases

## cat ~/.bash_aliases

alias rmtmp='cleanup_tmp_files.sh'
echo '# 5. "rmtmp" to remove temp files'

echo "aceactivate='source activate ansible-1.9.0.1'"
alias aceactivate='source activate ansible-1.9.0.1'

echo "acedeactivate='source deactivate ansible-1.9.0.1'"
alias acedeactivate='source deactivate ansible-1.9.0.1'

## ls -al ~/bin/acemenu/

drwxrwxr-x  2 cjs cjs 4096 Aug  8 21:18 helpfiles
-rwxr-----  1 cjs cjs 1037 Aug  8 21:18 menu
-rw-r-----  1 cjs cjs   19 Aug  8 20:37 menuitems.txt

## ls -al ~/bin/acemenu/helpfiles/

total 16
drwxrwxr-x 2 cjs cjs 4096 Aug  8 21:18 .
drwxr----- 3 cjs cjs 4096 Aug 22 11:59 ..
-rw-rw-r-- 1 cjs cjs  465 Aug  8 21:17 about.txt
-rw-rw-r-- 1 cjs cjs  554 Aug  8 20:34 contributing.txt

