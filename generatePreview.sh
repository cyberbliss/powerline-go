#!/bin/sh

FLAGS="-modules cwd,git,gcloud,root"
_currdir=$(pwd)
_pgo=$_currdir/release/powerline-go

mkdir -p /tmp/home/code/dotfiles;
cd /tmp/home/code/dotfiles/;
git init;
touch file1;
git add .;
git commit -m "commit";
touch file2;

mkdir -p /tmp/home/deep/down/into/the/abyss/of/directories/where/no/one/ever/comes/;
cd /tmp/home/deep/down/into/the/abyss/of/directories/where/no/one/ever/comes/;
git init;
touch file1;
git add .;
git commit -m "commit";
echo "test">file1;
git stash;

#export HOME=/tmp/home/

clear;

cd /tmp/home/code/dotfiles/;
$_pgo -shell bare -newline $FLAGS;
echo git branch;
git branch;

$_pgo -shell bare $FLAGS;
echo badcmd;
echo "bash: badcmd: command not found";

$_pgo -shell bare $FLAGS -error 1;
echo "cd /tmp/home/deep/down/into/the/abyss/of/directories/where/no/one/ever/comes/";
cd /tmp/home/deep/down/into/the/abyss/of/directories/where/no/one/ever/comes/;

$_pgo -shell bare $FLAGS;

# terraform
if hash terraform 2>/dev/null; then
    mkdir -p  /tmp/home/terraform && cd /tmp/home/terraform
    echo "create terraform workspace named 'production' at ~/terraform"
    terraform init 1>/dev/null && terraform workspace new production 1>/dev/null
    $_pgo -shell bare $FLAGS
fi

echo ""
cd /tmp/home

$_pgo -shell bare -mode nopowerline -newline -modules user,cwd,perms,git,mem,load,gcloud,kube,exit,root -shorten-gke-names
echo;
$_pgo -shell bare -newline -modules user,cwd,perms,git,mem,load,gcloud,kube,exit,root -shorten-gke-names
rm -rf /tmp/home;

echo;echo;
