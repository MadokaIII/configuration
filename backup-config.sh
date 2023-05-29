#!/bin/bash

export CONFIG_PATH=/Users/daoudlamalmi/.backup
export TEMP=$CONFIG_PATH/temp.txt
export TEMP_DIR=$CONFIG_PATH/temp
export CONF_DIR=$CONFIG_PATH/conf
export ASTRONVIM=/Users/daoudlamalmi/.config/nvim/lua/user

cd $ASTRONVIM

if [ -n "$(git status --porcelain)" ]; then 
  echo "Changes detected, starting the commit process"
  git add .
  git commit -m "Automated commit: Changes detected"
  git push
fi

cd $CONFIG_PATH
mkdir temp
touch temp.txt

if [ ! -d "conf" ]; then
    mkdir "conf"
fi

if [ ! -f "brew.txt" ]; then
  touch "brew.txt"
fi

if [ ! -f ".zshrc" ]; then
  touch ".zshrc"
fi

if [ ! -f ".skhdrc" ]; then
  touch ".skhdrc"
fi

if [ ! -f ".yabairc" ]; then
  touch ".yabairc"
fi

if [ ! -f "backup-config.sh" ]; then
  touch "backup-config.sh"
fi

brew list > $TEMP

DIFF=$(diff -u "brew.txt" "$TEMP")
DIFF_STATUS=$?

if [ $DIFF_STATUS -eq 1 ]; then
    cat $TEMP > brew.txt
    echo "$DIFF"
fi

cat "/Users/daoudlamalmi/.zshrc" > $TEMP

DIFF=$(diff -u ".zshrc" "$TEMP")
DIFF_STATUS=$?

if [ $DIFF_STATUS -eq 1 ]; then
    cat $TEMP > ".zshrc"
    echo "$DIFF"
fi

cat "/Users/daoudlamalmi/.yabairc" > $TEMP

DIFF=$(diff -u ".yabairc" "$TEMP")
DIFF_STATUS=$?

if [ $DIFF_STATUS -eq 1 ]; then
    cat $TEMP > ".yabairc"
    echo "$DIFF"
fi

cat "/Users/daoudlamalmi/.skhdrc" > $TEMP

DIFF=$(diff -u ".skhdrc" "$TEMP")
DIFF_STATUS=$?

if [ $DIFF_STATUS -eq 1 ]; then
    cat $TEMP > ".skhdrc"
    echo "$DIFF"
fi

cat "/Users/daoudlamalmi/backup-config.sh" > $TEMP

DIFF=$(diff -u "backup-config.sh" "$TEMP")
DIFF_STATUS=$?

if [ $DIFF_STATUS -eq 1 ]; then
    cat $TEMP > "backup-config.sh"
    echo "$DIFF"
fi

rsync -aqv --exclude='.git/' --exclude='.ds_store' --exclude='nvim/' "/Users/daoudlamalmi/.config/" "$TEMP_DIR"

DIFF=$(diff -ru "$TEMP_DIR" "$CONF_DIR")
DIFF_STATUS=$?

if [ $DIFF_STATUS -eq 1 ]; then 
    rsync -r $TEMP_DIR/ $CONF_DIR
    echo "$DIFF"
fi

rm $TEMP
rm -rf $TEMP_DIR

cd $CONFIG_PATH

if [ ! -d ".git" ]; then
  git init
  git remote add origin git@github.com:MadokaIII/configuration.git
fi

if [ ! -f ".gitignore" ]; then
  echo ".DS_Store" > .gitignore
  echo "*.log" >> .gitignore
  echo "node_modules/" >> .gitignore
  echo "__pycache__/" >> .gitignore
  echo "*.pyc" >> .gitignore
  echo "*.pyo" >> .gitignore
  echo "*.env" >> .gitignore
fi

#git pull origin main --allow-unrelated-histories --rebase

if [ -n "$(git status --porcelain)" ]; then 
  echo "Changes detected in conf directory, starting the commit process"
  git add .
  git commit -m "Automated commit: Changes detected in conf directory"
  git push origin main
fi

